import SwiftUI

struct HelpOverlayView: View {
    @Binding var isPresented: Bool
    @State private var messageText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Fondo
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    closeOverlay()
                }
            
            // Contenedor principal
            VStack(spacing: 0) {
                // Header con botón de cerrar
                headerView
                
                // Aqui va el contenido
                ScrollView {
                    VStack(spacing: 16) {
                        // Mensaje de bienvenida
                        welcomeMessage
                        
                        Spacer()
                    }
                    .padding()
                }
                .background(Color.white.opacity(0.95))
                
                // Input de mensaje en la parte inferior
                messageInputView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.85))
            .cornerRadius(20)
            .padding(20) // Margen general en todos los lados
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
    
    private var headerView: some View {
        HStack {
            // Icono de ayuda
            Image(systemName: "questionmark.circle.fill")
                .font(.title2)
                .foregroundColor(Color(hex: "#FFFFFF"))
            
            Text("Centro de Ayuda")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#FFFFFF"))
            
            Spacer()
            
            // Botón cerrar
            Button(action: {
                closeOverlay()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.95))
    }
    
    private var welcomeMessage: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 50))
                .foregroundColor(Color(hex: "#FFFFFF"))
            
            Text("Centro de ayuda")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "#1A344B"))
                .multilineTextAlignment(.center)
            
            Text("Si tiene alguna inquietud, por favor escribe su pregunta")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var messageInputView: some View {
        HStack(spacing: 12) {
            // Campo de texto
            TextField("Escribe tu mensaje...", text: $messageText, axis: .vertical)
                .focused($isTextFieldFocused)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
                .lineLimit(1...4)
            
            // Botón enviar
            Button(action: {
                sendMessage()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(messageText.isEmpty ? Color.gray : Color(hex: "#102334"))
                    .clipShape(Circle())
            }
            .disabled(messageText.isEmpty)
        }
        .padding()
        .background(Color.white.opacity(0.95))
    }
    
    private func closeOverlay() {
        isTextFieldFocused = false
        messageText = ""
        withAnimation {
            isPresented = false
        }
    }
    
    private func sendMessage() {
        print("Mensaje enviado: \(messageText)")
        // Aquí va la lógica para enviar el mensaje
        messageText = ""
    }
}

struct HelpOverlayModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                HelpOverlayView(isPresented: $isPresented)
                    .zIndex(999) // Asegura que esté por encima de todo
            }
        }
    }
}

extension View {
    func helpOverlay(isPresented: Binding<Bool>) -> some View {
        modifier(HelpOverlayModifier(isPresented: isPresented))
    }
}


#Preview {
    ZStack {
        // Vista de fondo
        Image("fondo")
            .resizable()
            .ignoresSafeArea()
        
        VStack {
            Text("Vista Principal")
                .font(.largeTitle)
            Spacer()
        }
        .helpOverlay(isPresented: .constant(true))
    }
}
