import SwiftUI

struct CustomInputField: View {
    let label: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isReadOnly: Bool
    let placeholder: String
    let onTap: (() -> Void)?

    init(
        label: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        isReadOnly: Bool = false,
        placeholder: String = "",
        onTap: (() -> Void)? = nil
    ) {
        self.label = label
        self._text = text
        self.keyboardType = keyboardType
        self.isReadOnly = isReadOnly
        self.placeholder = placeholder
        self.onTap = onTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            if isReadOnly {
                Button(action: onTap ?? {}) {
                    HStack {
                        Text(text.isEmpty ? placeholder : text)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    .keyboardType(keyboardType)
                    .foregroundColor(.white)
            }
        }
    }
}
