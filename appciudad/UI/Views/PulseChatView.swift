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
            print("⚠️ [PulseChat] activateChat bloqueado: isProcessing=\(isProcessing), chatActivated=\(chatActivated)")
            return
        }
        
        print("🚀 [PulseChat] Activando chat...")
        isProcessing = true
        
        let activateScript = "window.activateChatFromSwift();"
        webView.evaluateJavaScript(activateScript) { [weak self] _, error in
            if let error = error {
                print("❌ [PulseChat] Error al activar chat: \(error.localizedDescription)")
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
            print("✅ [PulseChat] jsReady recibido")
            // Intentar abrir inmediatamente cuando el JS esté listo
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.activateChat()
            }
        
        case "pulseDetected":
            print("✅ [PulseChat] pulseDetected recibido")
            // Cuando Pulse se detecta, abrir de inmediato
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.activateChat()
            }
            
        case "chatOpened":
            print("✅ [PulseChat] chatOpened recibido")
            isProcessing = false
            chatActivated = true
            
        case "chatError":
            print("❌ [PulseChat] chatError: \(body)")
            isProcessing = false
        
        case "scriptLoaded":
            print("✅ [PulseChat] Pulse script cargado desde: \(body["src"] ?? "unknown")")
        
        case "scriptError":
            print("❌ [PulseChat] Error cargando script: \(body["src"] ?? "unknown")")
            
        default:
            print("ℹ️ [PulseChat] Evento desconocido: \(event)")
            break
        }
    }
}

// MARK: - Navigation Delegate
extension PulseChatCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ [PulseChat] WebView cargado completamente")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ [PulseChat] Error en navegación: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("🔄 [PulseChat] Navegación iniciada")
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
                
                /* Ocultar el launcher flotante y botón cerrar de Pulse */
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
                [role="button"][aria-label*="Close"],
                /* Selectores específicos para la X interna */
                button[aria-label="Close"],
                button[aria-label="close"],
                button[title="Close"],
                button[title="close"],
                header button,
                header svg,
                [class*="header"] button,
                [class*="Header"] button,
                div > button:first-child svg,
                button > svg[viewBox*="24"],
                /* Ocultar SVG con formas de X */
                svg > path[d*="M"],
                svg > line[x1],
                /* Botones en esquinas superiores */
                div[style*="position: absolute"][style*="top"],
                div[style*="position: fixed"][style*="top"] {
                    display: none !important;
                    visibility: hidden !important;
                    opacity: 0 !important;
                    pointer-events: none !important;
                    width: 0 !important;
                    height: 0 !important;
                    max-width: 0 !important;
                    max-height: 0 !important;
                    overflow: hidden !important;
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
                let stylesApplied = false;
                
                // Función para aplicar estilos dentro del shadowRoot
                function applyStylesToShadowRoot(shadowRoot) {
                    try {
                        let style = shadowRoot.querySelector('style.pulse-custom-hide-close');
                        if (!style) {
                            style = document.createElement('style');
                            style.className = 'pulse-custom-hide-close';
                            style.innerHTML = 
                                '/* Ocultar TODOS los botones de cerrar */ ' +
                                'button[style*="top"], button[style*="right"], button[style*="position: absolute"] { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'button[style*="position:absolute"] { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'div > button:first-child { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'div > button:last-child { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'header button, header svg, header path { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                '[class*="header"] button, [class*="Header"] button { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                '[class*="close"], [class*="Close"] { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'button[aria-label*="close"], button[aria-label*="Close"], button[aria-label*="cerrar"] { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'button[title*="close"], button[title*="Close"], button[title*="cerrar"] { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'svg[class*="close"], svg[class*="Close"] { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'path[d*="M19"], path[d*="M18"] { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'button:first-of-type { display: none !important; visibility: hidden !important; opacity: 0 !important; } ' +
                                'div[style*="display: flex"] > button { display: none !important; visibility: hidden !important; opacity: 0 !important; }';
                            shadowRoot.appendChild(style);
                        }
                        
                        // Eliminar botones de cerrar del shadowRoot
                        const shadowButtons = shadowRoot.querySelectorAll('button, svg, path, [role="button"]');
                        shadowButtons.forEach(function(btn) {
                            const text = btn.textContent || '';
                            const ariaLabel = btn.getAttribute('aria-label') || '';
                            const title = btn.getAttribute('title') || '';
                            const parentHTML = btn.parentElement ? btn.parentElement.outerHTML : '';
                            
                            if (text.includes('×') || text.includes('✕') || 
                                ariaLabel.toLowerCase().includes('close') || 
                                title.toLowerCase().includes('close') ||
                                parentHTML.toLowerCase().includes('header')) {
                                btn.style.setProperty('display', 'none', 'important');
                                btn.style.setProperty('visibility', 'hidden', 'important');
                                btn.style.setProperty('opacity', '0', 'important');
                                btn.style.setProperty('pointer-events', 'none', 'important');
                                btn.remove();
                            }
                        });
                    } catch(e) {
                        // Error al aplicar estilos
                    }
                }
                
                // MutationObserver global que detecta shadowRoots INSTANTÁNEAMENTE
                const globalObserver = new MutationObserver(function(mutations) {
                    mutations.forEach(function(mutation) {
                        mutation.addedNodes.forEach(function(node) {
                            if (node.nodeType === 1) {
                                // Si el nodo tiene shadowRoot, aplicar estilos INMEDIATAMENTE
                                if (node.shadowRoot) {
                                    applyStylesToShadowRoot(node.shadowRoot);
                                }
                                // Buscar shadowRoots en hijos
                                const childrenWithShadow = node.querySelectorAll('*');
                                childrenWithShadow.forEach(function(child) {
                                    if (child.shadowRoot) {
                                        applyStylesToShadowRoot(child.shadowRoot);
                                    }
                                });
                            }
                        });
                    });
                });
                
                // Iniciar observación ANTES de abrir el chat
                globalObserver.observe(document.body, {
                    childList: true,
                    subtree: true
                });
                
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
                                // Aplicar estilos a cualquier shadowRoot existente ANTES de abrir
                                const allElements = document.querySelectorAll('*');
                                for (let i = 0; i < allElements.length; i++) {
                                    if (allElements[i].shadowRoot) {
                                        applyStylesToShadowRoot(allElements[i].shadowRoot);
                                    }
                                }
                                
                                // AHORA sí: Abrir el chat (el MutationObserver aplicará estilos INSTANTÁNEAMENTE)
                                PulseLiveChat.show();
                                chatOpened = true;
                                SwiftBridge.send('chatOpened');
                                
                                if (pulseCheckInterval) {
                                    clearInterval(pulseCheckInterval);
                                    pulseCheckInterval = null;
                                }
                                
                                // Aplicar estilos adicionales después de abrir (por si acaso)
                                setTimeout(function() {
                                    const allEls = document.querySelectorAll('*');
                                    for (let i = 0; i < allEls.length; i++) {
                                        if (allEls[i].shadowRoot) {
                                            applyStylesToShadowRoot(allEls[i].shadowRoot);
                                        }
                                    }
                                }, 10);
                                setTimeout(function() {
                                    const allEls = document.querySelectorAll('*');
                                    for (let i = 0; i < allEls.length; i++) {
                                        if (allEls[i].shadowRoot) {
                                            applyStylesToShadowRoot(allEls[i].shadowRoot);
                                        }
                                    }
                                }, 50);
                                setTimeout(function() {
                                    const allEls = document.querySelectorAll('*');
                                    for (let i = 0; i < allEls.length; i++) {
                                        if (allEls[i].shadowRoot) {
                                            applyStylesToShadowRoot(allEls[i].shadowRoot);
                                        }
                                    }
                                }, 100);
                                setTimeout(function() {
                                    const allEls = document.querySelectorAll('*');
                                    for (let i = 0; i < allEls.length; i++) {
                                        if (allEls[i].shadowRoot) {
                                            applyStylesToShadowRoot(allEls[i].shadowRoot);
                                        }
                                    }
                                }, 200);
                                setTimeout(function() {
                                    const allEls = document.querySelectorAll('*');
                                    for (let i = 0; i < allEls.length; i++) {
                                        if (allEls[i].shadowRoot) {
                                            applyStylesToShadowRoot(allEls[i].shadowRoot);
                                        }
                                    }
                                }, 500);
                                
                                // Aplicar estilos cada segundo de forma continua
                                setInterval(function() {
                                    const allEls = document.querySelectorAll('*');
                                    for (let i = 0; i < allEls.length; i++) {
                                        if (allEls[i].shadowRoot) {
                                            applyStylesToShadowRoot(allEls[i].shadowRoot);
                                        }
                                    }
                                }, 1000);
                                
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
        
        print("🔧 [PulseChat] Cargando HTML en WebView...")
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
