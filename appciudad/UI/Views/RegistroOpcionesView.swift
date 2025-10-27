import SwiftUI

struct RegistroOpcionesView: View {
    
    @StateObject private var viewModel: RegistroOpcionesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPulseChat = false
    
    init(registroResult: RegistroResult) {
        self._viewModel = StateObject(wrappedValue: RegistroOpcionesViewModel(registroResult: registroResult))
    }
    
    var body: some View {
        ZStack {
                // Fondo con imagen
                Image("fondo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header con logo y franja azul
                    headerView
                    
                    // Formulario de opciones
                    ScrollView {
                        opcionesCardView
                    }

                    fabView
                    
                    // Padding inferior mínimo para no solapar navbar
                    Color.clear.frame(height: 8)
                }
                
                VStack {
                    if viewModel.showToast {
                        ToastView(message: viewModel.toastMessage, isShowing: $viewModel.showToast)
                            .padding(.top, 100)
                    }
                    Spacer()
                }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .pulseChatOverlay(isPresented: $showPulseChat)
        // ✅ Cerrar al tocar cualquier opción del navbar
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToMainTab"))) { _ in
            NotificationCenter.default.post(name: NSNotification.Name("DismissRegistroOpcionesView"), object: nil)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CloseAllModalsAndNavigate"))) { _ in
            NotificationCenter.default.post(name: NSNotification.Name("DismissRegistroOpcionesView"), object: nil)
        }
    }
    
    
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
    
    private var opcionesCardView: some View {
        VStack(alignment: .leading, spacing: 24) {
            titleSection
            contentSection
            nextButtonSection
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.6))
        )
        .padding(.horizontal, 32)
        .padding(.top, 32)
    }
    
    private var titleSection: some View {
        Text("REGISTRARME")
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(Color(hex: "#1A344B"))
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var contentSection: some View {
        Group {
            if !viewModel.preguntas.isEmpty {
                preguntasListView
            } else {
                emptyStateView
            }
        }
    }
    
    private var preguntasListView: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.preguntas.enumerated()), id: \.offset) { index, pregunta in
                RadioButtonRow(
                    text: pregunta,
                    isSelected: viewModel.preguntaSeleccionada == pregunta
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.onPreguntaSeleccionada(pregunta)
                    }
                }
                
                if index < viewModel.preguntas.count - 1 {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("No se recibieron opciones de validación")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#1A344B"))
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
    }
    
    private var nextButtonSection: some View {
        Button(action: {
            viewModel.onSiguienteClicked()
        }) {
            Text("SIGUIENTE")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(viewModel.isSiguienteButtonDisabled ? Color.gray : Color(hex: "#102334"))
                .cornerRadius(25)
        }
        .disabled(viewModel.isSiguienteButtonDisabled)
        .padding(.top, 8)
    }
    
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

extension RegistroOpcionesView {
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

struct RadioButtonRow: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Radio button circle
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "#102334") : Color.gray, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "#102334"))
                            .frame(width: 12, height: 12)
                    }
                }
                
                // Text label
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#1A344B"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
