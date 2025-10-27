import SwiftUI

struct RegisterTextField: View {
    let placeholder: String
    let icon: String
    let isSecure: Bool
    @Binding var text: String

    init(placeholder: String, icon: String, isSecure: Bool = false, text: Binding<String>) {
        self.placeholder = placeholder
        self.icon = icon
        self.isSecure = isSecure
        self._text = text
    }

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}
