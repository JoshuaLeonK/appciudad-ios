import SwiftUI

extension Color {
    
    // MARK: - Colores principales de la aplicación
    
    /// Color principal desde Assets
    static let appPrimary = Color("appPrimary")
    
    /// Color azul principal (#102334)
    static let primaryBlue = Color(red: 16/255, green: 35/255, blue: 52/255)
    
    /// Color de texto principal (#1A344B)
    static let appTextPrimary = Color(red: 26/255, green: 52/255, blue: 75/255)
    
    /// Color de fondo para splash screen
    static let splashBackground = Color.black.opacity(0.65)
    
    /// Texto secundario
    static let secondaryText = Color.white.opacity(0.8)
    
    /// Campos de entrada
    static let inputBackground = Color.white.opacity(0.9)
    
    /// Overlay de cards
    static let cardOverlay = Color.white.opacity(0.25)
    
    /// Elementos de UI con transparencia
    static let overlayBackground = Color.black.opacity(0.3)
    
    // MARK: - Inicializadores para colores hexadecimales
    
    /// Inicializador para valores UInt hexadecimales (ej: 0x102334)
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    /// Inicializador para strings hexadecimales (ej: "#102334" o "102334")
    init(hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: alpha
        )
    }
    
    /// Inicializador alternativo para strings hexadecimales con sRGB
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - AppColors - Sistema de colores de la aplicación

extension Color {
    struct AppColors {
        static let primary = Color(hex: "102334")
        static let background = Color(hex: "F5F5F5")
        static let surface = Color.white
        static let error = Color.red
        static let success = Color.green
        static let warning = Color.orange
        
        // Colores de texto
        static let onPrimary = Color.white
        static let onBackground = Color.black
        static let onSurface = Color.black
        static let onError = Color.white
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Rectangle()
            .fill(Color.splashBackground)
            .frame(height: 100)
        
        Rectangle()
            .fill(Color(hex: 0x102334))
            .frame(height: 100)
        
        Rectangle()
            .fill(Color(hexString: "#102334"))
            .frame(height: 100)
        
        Rectangle()
            .fill(Color.AppColors.primary)
            .frame(height: 100)
        
        Rectangle()
            .fill(Color.primaryBlue)
            .frame(height: 100)
    }
    .padding()
}
