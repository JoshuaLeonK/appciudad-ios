import SwiftUI

struct IdentificacionView: View {
    @StateObject private var viewModel = IdentificacionViewModel()
    @State private var showPulseChat = false
    @State private var showQRScanner = false
    @Environment(\.dismiss) private var dismiss
    
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
                // Header con franja azul y logo
                headerView
                
                // Contenido principal
                ScrollView {
                    VStack(spacing: 24) {
                        // Título
                        Text("Identificación:")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 32)
                        
                        // Campo de Identificación
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Ingrese número de identificación", text: $viewModel.identificacion)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.3))
                                )
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .keyboardType(.numberPad)
                                .disabled(viewModel.isLoading)
                                .placeholder(when: viewModel.identificacion.isEmpty) {
                                    Text("Ingrese el número de identificación")
                                        .foregroundColor(.white.opacity(0.9))
                                        .font(.system(size: 16))
                                        .padding(.leading, 16)
                                }
                        }
                        
                        // Título Nombres
                        Text("Nombres:")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Campo de Nombres
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Ingrese nombres del funcionario", text: $viewModel.nombres)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.3))
                                )
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .autocapitalization(.words)
                                .disabled(viewModel.isLoading)
                                .placeholder(when: viewModel.nombres.isEmpty) {
                                    Text("Ingrese el nombres del funcionario")
                                        .foregroundColor(.white.opacity(0.9))
                                        .font(.system(size: 16))
                                        .padding(.leading, 16)
                                }
                        }
                        
                        // Botón Buscar
                        Button(action: {
                            viewModel.buscarFuncionario()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#102334")))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            } else {
                                Text("Buscar")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(hex: "#102334"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                        )
                        .disabled(viewModel.isLoading)
                        .padding(.top, 8)
                        
                        // Botón Escanear
                        Button(action: {
                            showQRScanner = true
                        }) {
                            Text("Escanear")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(hex: "#102334"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                )
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
                
                Spacer()
            }
            
            // Botón flotante de ayuda
            VStack {
                Spacer()
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
            
            // Navbar inferior
            VStack {
                Spacer()
                CustomBottomNavigationView(
                    selectedTab: Binding(
                        get: { .servicios },
                        set: { _ in }
                    ),
                    onTabSelected: { tab in
                        dismiss()
                        NotificationCenter.default.post(
                            name: NSNotification.Name("NavigateToMainTab"),
                            object: tab
                        )
                    },
                    allowNoneSelected: true
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .overlay(
            Group {
                if viewModel.shouldShowResultView, let funcionario = viewModel.funcionarioData {
                    IdentificacionRptView(funcionario: funcionario)
                        .transition(.opacity)
                }
            }
        )
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("DismissIdentificacionRptView"))) { _ in
            viewModel.shouldShowResultView = false
        }
        .pulseChatOverlay(isPresented: $showPulseChat)
        .fullScreenCover(isPresented: $showQRScanner) {
            QRScannerView(isPresented: $showQRScanner) { scannedCode in
                viewModel.escanearQR(token: scannedCode)
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Header View
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
}

#Preview {
    IdentificacionView()
}

