import SwiftUI

struct LoginTextField: View {
    let placeholder: String
    let icon: String
    var isSecure: Bool = false
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let onTap: (() -> Void)?

    init(
        placeholder: String,
        icon: String,
        isSecure: Bool = false,
        text: Binding<String> = .constant(""),
        keyboardType: UIKeyboardType = .default,
        onTap: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.icon = icon
        self.isSecure = isSecure
        self._text = text
        self.keyboardType = keyboardType
        self.onTap = onTap
    }

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 20)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
            } else {
                if let onTap = onTap {
                    Button(action: onTap) {
                        HStack {
                            Text(text.isEmpty ? placeholder : text)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.white)
                        .keyboardType(keyboardType)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    LoginTextField(placeholder: "Email", icon: "envelope.fill", text: .constant(""))
}
