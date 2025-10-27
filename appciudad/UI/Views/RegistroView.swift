import SwiftUI

struct RegistroView: View {
    @StateObject private var viewModel = RegistroViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showPulseChat = false
    
    // Estados para focus
    @FocusState private var focusedField: RegistroField?
    
    // Estado local para manejar alertas
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                
                // Card de registro
                ScrollView {
                    ZStack(alignment: .bottom) {
                        // Rectángulo de fondo con inputs (incluyendo espacio para el botón)
                        VStack(spacing: 20) {
                            Text("REGISTRO")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(hex: "#1A344B"))
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            VStack(spacing: 16) {
                                // Campo de Número de Identificación
                                CustomTextField(
                                    title: "Número de Identificación",
                                    placeholder: "Ingresa tu número",
                                    text: $viewModel.numeroIdentificacion,
                                    keyboardType: .numberPad,
                                    focusState: $focusedField,
                                    focusValue: .numeroIdentificacion
                                )
                                
                                // Campo de Fecha de Expedición (con picker)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Fecha de Expedición")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Button(action: {
                                        viewModel.showDatePickerAction()
                                    }) {
                                        HStack {
                                            Text(viewModel.fechaExpedicion.isEmpty ? "Selecciona la fecha" : viewModel.fechaExpedicion)
                                                .foregroundColor(viewModel.fechaExpedicion.isEmpty ? .gray : .black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "calendar")
                                                .foregroundColor(Color(hex: "#1A344B"))
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(25)
                                    }
                                }
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
                            viewModel.validarUsuario()
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                
                                Text(viewModel.buttonTitle)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(hex: "#102334"))
                        )
                        .disabled(viewModel.isValidarButtonDisabled)
                        .opacity(viewModel.isValidarButtonDisabled ? 0.5 : 1.0)
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
        // Focus automático al aparecer
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .numeroIdentificacion
            }
        }
        // Observar errores del ViewModel
        .onChange(of: viewModel.errorMessage) { errorMsg in
            if let error = errorMsg {
                alertMessage = error
                showAlert = true
            }
        }
        // Mostrar RegistroOpcionesView como overlay para mantener navbar visible
        .overlay(
            Group {
                if viewModel.navigateToOpciones, let result = viewModel.registroResult {
                    RegistroOpcionesView(registroResult: result)
                        .transition(.opacity)
                }
            }
        )
        // Alert para mostrar errores
        .alert("Error", isPresented: $showAlert) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(alertMessage)
        }
        // DatePicker sheet
        .sheet(isPresented: $viewModel.showDatePicker) {
            datePickerSheet
        }
        // ✅ Escuchar notificaciones de navegación del navbar para cerrar RegistroView
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToMainTab"))) { notification in
            if let tab = notification.object as? NavigationTab {
                dismissParentAndSelf()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CloseAllModalsAndNavigate"))) { notification in
            dismissParentAndSelf()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissRegistroOpcionesView"))) { _ in
            viewModel.navigationHandled()
            viewModel.navigateToOpciones = false
        }
    }
    
    private func dismissParentAndSelf() {
        NotificationCenter.default.post(
            name: NSNotification.Name("DismissRegistroView"),
            object: nil
        )
    }
}

// Enum para los campos de registro
enum RegistroField: Hashable {
    case numeroIdentificacion
    case fechaExpedicion
}

extension RegistroView {
    
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
    
    
    // Date Picker Sheet
    private var datePickerSheet: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Selecciona la fecha",
                    selection: $viewModel.selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Fecha de Expedición")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        viewModel.setDateFromPicker()
                        viewModel.showDatePicker = false
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        viewModel.showDatePicker = false
                    }
                }
            }
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

extension RegistroView {
    
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
    RegistroView()
}
