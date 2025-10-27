import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var style: CustomButtonStyle = .primary
    var isEnabled: Bool = true
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: {
            if isEnabled && !isLoading {
                action()
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                }
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isEnabled ? style.foregroundColor : style.disabledForegroundColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                isEnabled ? style.backgroundColor : style.disabledBackgroundColor
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

enum CustomButtonStyle {
    case primary
    case secondary
    case danger
    case success
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return Color("PrimaryBlue") // Color #102334 definido en Assets
        case .secondary:
            return Color.gray.opacity(0.8)
        case .danger:
            return Color.red
        case .success:
            return Color.green
        }
    }
    
    var foregroundColor: Color {
        return .white
    }
    
    var disabledBackgroundColor: Color {
        return Color.gray.opacity(0.5)
    }
    
    var disabledForegroundColor: Color {
        return Color.white.opacity(0.6)
    }
    
    var borderColor: Color {
        return Color.clear
    }
    
    var borderWidth: CGFloat {
        return 0
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(
            title: "INICIAR",
            action: { print("Primary button tapped") },
            style: .primary
        )
        
        CustomButton(
            title: "CARGANDO...",
            action: { },
            style: .primary,
            isEnabled: true,
            isLoading: true
        )
        
        CustomButton(
            title: "DESHABILITADO",
            action: { },
            style: .primary,
            isEnabled: false
        )
        
        CustomButton(
            title: "CANCELAR",
            action: { print("Secondary button tapped") },
            style: .secondary
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
