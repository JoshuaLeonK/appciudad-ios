import SwiftUI
import WebKit

// MARK: - PulseChatView
struct PulseChatView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var coordinator = PulseChatCoordinator()
    
    var body: some View {
        ZStack {
            // Fondo semi-transparente
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 0) {
                // Header con botón cerrar
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)
                    }
                    .padding()
                }
                .background(Color(hex: "#102334"))
                
                // WebView con el chat de Pulse
                PulseChatWebView(coordinator: coordinator)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(20)
        }
    }
}

// MARK: - Coordinator
class PulseChatCoordinator: NSObject, ObservableObject {
    weak var webView: WKWebView?
    private var isProcessing = false
    private var chatActivated = false
    
    // Función para activar el chat desde Swift
    func activateChat() {
        guard let webView = webView, !isProcessing, !chatActivated else {
            return
        }
        
        isProcessing = true
        
        let activateScript = "window.activateChatFromSwift();"
        webView.evaluateJavaScript(activateScript) { [weak self] _, error in
            if let error = error {
                self?.isProcessing = false
            }
        }
    }
}

// MARK: - Script Message Handler
extension PulseChatCoordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let event = body["event"] as? String else {
            return
        }
        
        switch event {
        case "jsReady":
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.activateChat()
            }
            
        case "chatOpened":
            isProcessing = false
            chatActivated = true
            
        case "chatError":
            isProcessing = false
            
        default:
            break
        }
    }
}

// MARK: - Navigation Delegate
extension PulseChatCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // WebView cargado
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Error en navegación
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Navegación iniciada
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

// MARK: - PulseChatWebView
struct PulseChatWebView: UIViewRepresentable {
    @ObservedObject var coordinator: PulseChatCoordinator
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webConfiguration.websiteDataStore = .default()
        
        let userContentController = WKUserContentController()
        userContentController.add(coordinator, name: "swiftBridge")
        webConfiguration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = coordinator
        webView.backgroundColor = .white
        webView.isOpaque = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif
        
        coordinator.webView = webView
        
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline' 'unsafe-eval' data: blob:;">
            <title>Chat de Ayuda</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                html, body {
                    width: 100vw;
                    height: 100vh;
                    margin: 0;
                    padding: 0;
                    overflow: hidden;
                    background-color: #ffffff;
                    -webkit-overflow-scrolling: touch;
                    position: fixed;
                    top: 0;
                    left: 0;
                }
                
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                }
                
                #chatContainer {
                    width: 100%;
                    height: 100%;
                    display: block;
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    margin: 0;
                    padding: 0;
                    z-index: 9999;
                    overflow: hidden;
                }
                
                /* FORZAR que Pulse ocupe el 100% del contenedor */
                #chatContainer > *,
                #chatContainer div,
                #chatContainer iframe,
                div[id*="pulse"],
                div[class*="pulse"],
                iframe[id*="pulse"],
                iframe[src*="pulse"] {
                    width: 100% !important;
                    height: 100% !important;
                    max-width: 100% !important;
                    max-height: 100% !important;
                    min-width: 100% !important;
                    min-height: 100% !important;
                    position: absolute !important;
                    top: 0 !important;
                    left: 0 !important;
                    right: 0 !important;
                    bottom: 0 !important;
                    margin: 0 !important;
                    padding: 0 !important;
                    transform: none !important;
                    border: none !important;
                }
                
                /* Ocultar el launcher flotante y botón cerrar de Pulse - Versión mejorada */
                .pulse-chat-launcher,
                .pulse-launcher-button,
                button[class*="pulse-launcher"],
                div[class*="pulse-launcher"],
                button[class*="close"],
                button[class*="Close"],
                button[aria-label*="close"],
                button[aria-label*="Close"],
                button[aria-label*="cerrar"],
                button[title*="close"],
                button[title*="Close"],
                button[title*="cerrar"],
                .pulse-close-button,
                div[class*="close-button"],
                [class*="CloseButton"],
                svg[class*="close"],
                path[d*="M19"],
                /* Selectores adicionales más específicos */
                div[id*="pulse"] button[class*="close"],
                div[id*="pulse"] svg[class*="close"],
                div[id*="pulse"] path[d*="M19"],
                iframe[id*="pulse"] button,
                [role="button"][aria-label*="close"],
                [role="button"][aria-label*="Close"] {
                    display: none !important;
                    visibility: hidden !important;
                    opacity: 0 !important;
                    pointer-events: none !important;
                    width: 0 !important;
                    height: 0 !important;
                }
            </style>
        </head>
        <body>
            <div id="chatContainer"></div>
            
            <script>
                
                const SwiftBridge = {
                    send: function(event, data = {}) {
                        const message = { event, ...data };
                        try {
                            window.webkit.messageHandlers.swiftBridge.postMessage(message);
                        } catch (error) {
                            // Error al enviar mensaje
                        }
                    }
                };
                
                let chatOpened = false;
                let pulseCheckInterval = null;
                
                // Función principal para activar el chat
                window.activateChatFromSwift = function() {
                    if (chatOpened) {
                        return;
                    }
                    
                    function attemptOpen(retries = 0) {
                        const maxRetries = 60; // 30 segundos máximo
                        
                        if (typeof PulseLiveChat !== 'undefined' && 
                            typeof PulseLiveChat.show === 'function') {
                            
                            try {
                                PulseLiveChat.show();
                                chatOpened = true;
                                
                                SwiftBridge.send('chatOpened');
                                
                                if (pulseCheckInterval) {
                                    clearInterval(pulseCheckInterval);
                                    pulseCheckInterval = null;
                                }
                                
                                // Función para forzar estilos en Pulse
                                function applyPulseAdjustments() {
                                    // 1. Ocultar botones de cerrar
                                    const closeButtons = document.querySelectorAll('button, a, span, svg, path, div[role="button"]');
                                    closeButtons.forEach(function(btn) {
                                        const text = btn.textContent || '';
                                        const ariaLabel = btn.getAttribute('aria-label') || '';
                                        const title = btn.getAttribute('title') || '';
                                        const className = btn.className || '';
                                        
                                        if (text.includes('×') || text.includes('✕') || 
                                            text.toLowerCase().includes('close') || 
                                            text.toLowerCase().includes('cerrar') ||
                                            ariaLabel.toLowerCase().includes('close') || 
                                            ariaLabel.toLowerCase().includes('cerrar') ||
                                            title.toLowerCase().includes('close') ||
                                            title.toLowerCase().includes('cerrar') ||
                                            className.toLowerCase().includes('close')) {
                                            btn.style.display = 'none';
                                            btn.style.visibility = 'hidden';
                                            btn.style.opacity = '0';
                                            btn.style.pointerEvents = 'none';
                                            btn.style.width = '0';
                                            btn.style.height = '0';
                                        }
                                    });
                                    
                                    // 2. FORZAR posicionamiento en elementos de Pulse (necesario porque Pulse usa inline styles)
                                    const pulseElements = document.querySelectorAll(
                                        'div[id*="pulse"], div[class*="pulse"], iframe[id*="pulse"], iframe[src*="pulse"]'
                                    );
                                    pulseElements.forEach(function(el) {
                                        el.style.width = '100%';
                                        el.style.height = '100%';
                                        el.style.maxWidth = '100%';
                                        el.style.maxHeight = '100%';
                                        el.style.position = 'absolute';
                                        el.style.top = '0';
                                        el.style.left = '0';
                                        el.style.right = '0';
                                        el.style.bottom = '0';
                                        el.style.margin = '0';
                                        el.style.padding = '0';
                                        el.style.transform = 'none';
                                    });
                                    
                                    // 3. Forzar en hijos directos del chatContainer también
                                    const chatContainer = document.getElementById('chatContainer');
                                    if (chatContainer) {
                                        const children = chatContainer.children;
                                        for (let i = 0; i < children.length; i++) {
                                            const child = children[i];
                                            child.style.width = '100%';
                                            child.style.height = '100%';
                                            child.style.position = 'absolute';
                                            child.style.top = '0';
                                            child.style.left = '0';
                                        }
                                    }
                                }
                                
                                // Aplicar ajustes inmediatamente
                                applyPulseAdjustments();
                                
                                // Aplicar varias veces para asegurar que funcione
                                setTimeout(applyPulseAdjustments, 100);
                                setTimeout(applyPulseAdjustments, 300);
                                setTimeout(applyPulseAdjustments, 500);
                                setTimeout(applyPulseAdjustments, 1000);
                                
                                // Aplicar periódicamente
                                setInterval(applyPulseAdjustments, 2000);
                                
                                // Observer para detectar cambios en el DOM
                                const observer = new MutationObserver(function(mutations) {
                                    applyPulseAdjustments();
                                    
                                    mutations.forEach(function(mutation) {
                                        if (mutation.addedNodes.length > 0) {
                                            mutation.addedNodes.forEach(function(node) {
                                                if (node.nodeType === 1) {
                                                    const id = node.id || '';
                                                    const className = node.className || '';
                                                    if (id.includes('pulse') || className.toString().includes('pulse')) {
                                                        setTimeout(applyPulseAdjustments, 100);
                                                        setTimeout(applyPulseAdjustments, 300);
                                                        setTimeout(applyPulseAdjustments, 500);
                                                    }
                                                }
                                            });
                                        }
                                    });
                                });
                                
                                observer.observe(document.body, {
                                    childList: true,
                                    subtree: true,
                                    attributes: true,
                                    attributeFilter: ['style', 'class']
                                });
                                
                            } catch (error) {
                                SwiftBridge.send('chatError', { error: error.toString() });
                            }
                            
                        } else if (retries < maxRetries) {
                            setTimeout(() => attemptOpen(retries + 1), 500);
                        } else {
                            SwiftBridge.send('chatError', { error: 'Timeout al cargar PulseLiveChat' });
                        }
                    }
                    
                    // Iniciar intentos de apertura
                    attemptOpen();
                };
                
                // Polling para detectar cuándo PulseLiveChat se carga
                pulseCheckInterval = setInterval(function() {
                    if (typeof PulseLiveChat !== 'undefined') {
                        SwiftBridge.send('pulseDetected');
                        clearInterval(pulseCheckInterval);
                        pulseCheckInterval = null;
                    }
                }, 500);
                
                // Notificar cuando el DOM y scripts estén listos
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', function() {
                        setTimeout(function() {
                            SwiftBridge.send('jsReady');
                        }, 1000);
                    });
                } else {
                    setTimeout(function() {
                        SwiftBridge.send('jsReady');
                    }, 1000);
                }
            </script>
            
            <script 
                src="https://cdn.pulse.is/livechat/loader.js" 
                data-live-chat-id="68da9b909c298eec010f7e0f" 
                async
                onload="window.webkit.messageHandlers.swiftBridge.postMessage({event: 'scriptLoaded', src: this.src});"
                onerror="window.webkit.messageHandlers.swiftBridge.postMessage({event: 'scriptError', src: this.src});">
            </script>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlString, baseURL: URL(string: "https://cdn.pulse.is/"))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No se necesita actualización
    }
}

// MARK: - Modificador de Vista
struct PulseChatModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                PulseChatView()
            }
    }
}

extension View {
    func pulseChatOverlay(isPresented: Binding<Bool>) -> some View {
        self.modifier(PulseChatModifier(isPresented: isPresented))
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var showChat = false
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    Text("App Principal")
                        .font(.largeTitle)
                    
                    Button("Abrir Chat de Ayuda") {
                        showChat = true
                    }
                    .padding()
                    .background(Color(hex: "#102334"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .pulseChatOverlay(isPresented: $showChat)
        }
    }
    
    return PreviewWrapper()
}
