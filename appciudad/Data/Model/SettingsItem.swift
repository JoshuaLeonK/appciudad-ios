import Foundation

// SettingsItem Model
struct SettingsItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let iconName: String
    let settingsType: SettingsType
}

// SettingsType Enum
enum SettingsType: String, CaseIterable {
    case iniciar = "iniciar"
    case registrar = "registrar"
    case acerca = "acerca"
    case visualizacion = "visualizacion"
    
    var displayTitle: String {
        switch self {
        case .iniciar: return "INICIAR"
        case .registrar: return "REGISTRARME"
        case .acerca: return "ACERCA DE LA APP"
        case .visualizacion: return "VISUALIZACIÓN"
        }
    }
    
    var iconName: String {
        switch self {
        case .iniciar: return "user"
        case .registrar: return "registro"
        case .acerca: return "baq"
        case .visualizacion: return "view"
        }
    }
    
    var systemIconName: String {
        switch self {
        case .iniciar: return "person.fill"
        case .registrar: return "person.badge.plus.fill"
        case .acerca: return "info.circle.fill"
        case .visualizacion: return "eye.fill"
        }
    }
}

// Navigation Destination Enum
enum SettingsDestination {
    case login
    case register
    case about
    case visualization
    case main
    
    var screenIdentifier: String {
        switch self {
        case .login: return "LoginView"
        case .register: return "RegisterView"
        case .about: return "AboutView"
        case .visualization: return "VisualizationView"
        case .main: return "MainView"
        }
    }
}
