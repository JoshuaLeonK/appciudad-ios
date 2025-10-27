import SwiftUI

struct InicioView: View {
    @StateObject private var viewModel = InicioViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showPulseChat = false
    
    // ✅ Estado para controlar el focus
    @FocusState private var focusedField: LoginField?
    
    var body: some View {
        ZStack {
            // Fondo con imagen
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Capa con transparencia
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con franja azul (desde navbar hasta tope)
                headerView
                
                // Card de login
                ScrollView {
                    ZStack(alignment: .bottom) {
                        // Rectángulo de fondo con inputs (incluyendo espacio para el botón)
                        VStack(spacing: 20) {
                            Text(AppConstants.Text.Login.title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(hex: "#1A344B"))
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            VStack(spacing: AppConstants.UI.verticalSpacing) {
                                CustomTextField(
                                    title: AppConstants.Text.Login.identificationLabel,
                                    placeholder: AppConstants.Text.Login.identificationPlaceholder,
                                    text: $viewModel.numeroIdentificacion,
                                    keyboardType: .numberPad,
                                    focusState: $focusedField,
                                    focusValue: .identification
                                )
                                
                                CustomTextField(
                                    title: AppConstants.Text.Login.passwordLabel,
                                    placeholder: AppConstants.Text.Login.passwordPlaceholder,
                                    text: $viewModel.contrasena,
                                    isSecure: true,
                                    focusState: $focusedField,
                                    focusValue: .password
                                )
                            }
                            
                            // Espacio invisible para el botón
                            Spacer()
                                .frame(height: 50)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.6))
                        )
                        
                        // Botón superpuesto encima del rectángulo
                        Button(action: {
                            hideKeyboard()
                            viewModel.hacerLogin()
                        }) {
                            Text(viewModel.loginButtonText)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(hex: "#102334"))
                        )
                        .disabled(!viewModel.isLoginButtonEnabled)
                        .opacity(viewModel.isLoginButtonEnabled ? 1.0 : 0.5)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                }
                
                Spacer()
                
                // FAB de ayuda
                fabView
            }
        }
        .pulseChatOverlay(isPresented: $showPulseChat)
        // ✅ Focus automático al aparecer
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .identification
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(AppConstants.Text.Alerts.ok) {
                viewModel.alertShown()
                
                // Si el login fue exitoso, cerrar padre (que cerrará al hijo automáticamente)
                if viewModel.loginSuccessful {
                    dismissParentAndSelf()
                    viewModel.loginSuccessHandled()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        // ✅ Escuchar notificaciones de navegación del navbar para cerrar InicioView
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToMainTab"))) { notification in
            if let tab = notification.object as? NavigationTab {
                dismissParentAndSelf()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CloseAllModalsAndNavigate"))) { notification in
            dismissParentAndSelf()
        }
    }
    
    private func dismissParentAndSelf() {
        NotificationCenter.default.post(
            name: NSNotification.Name("DismissInicioView"),
            object: nil
        )
    }
}

// Enum para identificar los campos
enum LoginField: Hashable {
    case identification
    case password
}

extension InicioView {
    
    // Header con franja azul (igual a MainHeaderView)
    private var headerView: some View {
        VStack(spacing: 0) {
            // Franja azul con logo
            ZStack {
                Color(hex: "#102334")
                    .frame(height: 75)
                
                Image(AppConstants.Images.logo)
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

extension InicioView {
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    InicioView()
}
