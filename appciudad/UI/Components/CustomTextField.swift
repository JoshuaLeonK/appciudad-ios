import SwiftUI

struct CustomTextField<T: Hashable>: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    // ✅ Parámetros opcionales para focus
    var focusState: FocusState<T?>.Binding? = nil
    var focusValue: T? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(CustomTextFieldStyle())
                        .applyFocus(focusState: focusState, focusValue: focusValue)
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(keyboardType)
                        .applyFocus(focusState: focusState, focusValue: focusValue)
                }
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(25)
            .foregroundColor(.black)
            .font(.body)
    }
}

// ✅ Extension para aplicar focus de manera condicional
extension View {
    @ViewBuilder
    func applyFocus<T: Hashable>(focusState: FocusState<T?>.Binding?, focusValue: T?) -> some View {
        if let focusState = focusState, let focusValue = focusValue {
            self.focused(focusState, equals: focusValue)
        } else {
            self
        }
    }
}

// ✅ Preview con focus funcional
#Preview {
    PreviewWithFocus()
}

private struct PreviewWithFocus: View {
    @State private var identificacion = ""
    @State private var contrasena = ""
    @FocusState private var focusedField: PreviewField?
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack(spacing: 20) {
                CustomTextField(
                    title: "Número de identificación:",
                    placeholder: "Ingresa tu número",
                    text: $identificacion,
                    keyboardType: .numberPad,
                    focusState: $focusedField,
                    focusValue: .identificacion
                )
                
                CustomTextField(
                    title: "Contraseña:",
                    placeholder: "Ingresa tu contraseña",
                    text: $contrasena,
                    isSecure: true,
                    focusState: $focusedField,
                    focusValue: .contrasena
                )
                
                // Botones para probar el focus
                HStack {
                    Button("Focus ID") {
                        focusedField = .identificacion
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(8)
                    
                    Button("Focus Pass") {
                        focusedField = .contrasena
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(8)
                }
                .padding(.top)
            }
            .padding()
        }
        .onAppear {
            // Focus automático en el primer campo
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .identificacion
            }
        }
    }
}

private enum PreviewField: Hashable {
    case identificacion
    case contrasena
}
