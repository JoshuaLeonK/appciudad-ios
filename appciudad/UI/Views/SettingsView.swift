import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showPulseChat = false
    @Environment(\.dismiss) private var dismiss
    
    // Estados para la visualizacion de las vistas
    @State private var showLogin = false
    @State private var showRegister = false
    @State private var showAbout = false
    @State private var showVisualization = false
    
    var body: some View {
        ZStack {
            // Fondo con imagen
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Capa semi transparente
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con franja azul (igual a TramitesView y MapaCiudadView)
                headerView
                
                // Contenido principal
                ScrollView {
                    VStack(spacing: 20) {
                        Text("AJUSTES")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "#1A344B"))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(spacing: 16) {
                            SettingsOptionButton(
                                title: "Iniciar Sesión",
                                icon: "person.circle.fill"
                            ) {
                                handleNavigation(to: .login)
                            }
                            
                            SettingsOptionButton(
                                title: "Registrarme",
                                icon: "person.badge.plus.fill"
                            ) {
                                handleNavigation(to: .register)
                            }
                            
                            SettingsOptionButton(
                                title: "Acerca de",
                                icon: "info.circle.fill"
                            ) {
                                handleNavigation(to: .about)
                            }
                            
                            SettingsOptionButton(
                                title: "Visualización",
                                icon: "eye.circle.fill"
                            ) {
                                handleNavigation(to: .visualization)
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.6))
                    )
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                }
                
                Spacer()
                
                // FAB de ayuda
                fabView
            }
        }
        .pulseChatOverlay(isPresented: $showPulseChat)
        // InicioView como overlay para mantener navbar visible
        .overlay(
            Group {
                if showLogin {
                    InicioView()
                        .transition(.opacity)
                }
            }
        )
        // RegistroView como overlay para mantener navbar visible
        .overlay(
            Group {
                if showRegister {
                    RegistroView()
                        .transition(.opacity)
                }
            }
        )
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .sheet(isPresented: $showVisualization) {
            VisualizationView()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissSettingsView"))) { _ in
            dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissInicioView"))) { _ in
            showLogin = false
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissRegistroView"))) { _ in
            showRegister = false
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CloseAllModalsAndNavigate"))) { notification in
            
            // Cerrar los modales abiertos
            showLogin = false
            showRegister = false
            showAbout = false
            showVisualization = false
            
            // Cerrar SettingsView
            dismiss()
        }
    }
    
    private func handleNavigation(to destination: NavigationDestination) {
        switch destination {
        case .login:
            showLogin = true
            
        case .register:
            showRegister = true
            
        case .about:
            showAbout = true
            
        case .visualization:
            showVisualization = true
            
        case .main:
            break
        }
    }
}

extension SettingsView {
    
    // Header con franja azul (igual a MainHeaderView)
    private var headerView: some View {
        VStack(spacing: 0) {
            // Franja azul con logo
            ZStack {
                Color(hex: "#102334")
                    .frame(height: 75)
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding(.vertical, 12)
            }
            .padding(.top, 32)
        }
    }
    
    
    // FAB de ayuda
    private var fabView: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation {
                    showPulseChat = true
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image("ayuda")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 60)
        }
    }
}

struct SettingsOptionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color(hex: "#1A344B"))
                    .frame(width: 30)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "#1A344B"))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#1A344B").opacity(0.7))
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum NavigationDestination {
    case login
    case register
    case about
    case visualization
    case main
}

#Preview {
    SettingsView()
}
