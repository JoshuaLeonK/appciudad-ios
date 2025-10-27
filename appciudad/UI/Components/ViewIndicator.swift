import SwiftUI

/// Componente  para indicar en qué vista se encuentra el usuario
struct ViewIndicator: View {
    let viewName: String
    let backgroundColor: Color
    let textColor: Color
    
    init(
        viewName: String,
        backgroundColor: Color = Color.white.opacity(0.2),
        textColor: Color = Color.white.opacity(0.8)
    ) {
        self.viewName = viewName
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "location.circle.fill")
                    .font(.caption)
                    .foregroundColor(textColor)
                
                Text("Estás en la vista: \(viewName.uppercased())")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .cornerRadius(8)
        }
    }
}

extension ViewIndicator {
    static func `default`(viewName: String) -> ViewIndicator {
        ViewIndicator(viewName: viewName)
    }
    
    static func accent(viewName: String) -> ViewIndicator {
        ViewIndicator(
            viewName: viewName,
            backgroundColor: Color.blue.opacity(0.3),
            textColor: Color.white
        )
    }
    
    static func success(viewName: String) -> ViewIndicator {
        ViewIndicator(
            viewName: viewName,
            backgroundColor: Color.green.opacity(0.3),
            textColor: Color.white
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 20) {
            ViewIndicator.default(viewName: "Configuración")
            ViewIndicator.accent(viewName: "Login")
            ViewIndicator.success(viewName: "Registro")
        }
    }
}
