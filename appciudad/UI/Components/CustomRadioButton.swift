import SwiftUI

struct CustomRadioButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Círculo del radio button
                Circle()
                    .stroke(Color.appPrimary, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(isSelected ? Color.appPrimary : Color.clear)
                            .frame(width: 12, height: 12)
                    )

                // Texto
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(.appTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack {
        CustomRadioButton(text: "Opción 1", isSelected: true) {}
        CustomRadioButton(text: "Opción 2", isSelected: false) {}
    }
    .padding()
}
