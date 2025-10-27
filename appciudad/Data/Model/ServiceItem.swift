import Foundation

struct ServiceItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    let serviceType: ServiceType
}

// ServiceType
enum ServiceType: String, CaseIterable {
    case eventos = "eventos"
    case novedades = "novedades"
    case clima = "clima"
    case identificacion = "identificacion"
    case rutas = "rutas"
    case adopcion = "adopcion"
    case transmetro = "transmetro"
    case sibus = "sibus"
    case directorio = "directorio"
    case linea195 = "195"
    
    var displayName: String {
        switch self {
        case .eventos: return "Eventos"
        case .novedades: return "Novedades"
        case .clima: return "Clima"
        case .identificacion: return "Identificacion"
        case .rutas: return "Rutas"
        case .adopcion: return "Adopcion Animal"
        case .transmetro: return "Transmetro"
        case .sibus: return "SIBUS"
        case .directorio: return "Directorio"
        case .linea195: return "195"
        }
    }
}

// Navigation Tab
enum NavigationTab: String, CaseIterable {
    case servicios = "servicios"
    case tramites = "tramites"
    case mapaCiudad = "mapa_ciudad"
    case ajustes = "ajustes"
    
    
    var displayName: String {
            switch self {
            case .servicios: return "Servicios"
            case .tramites: return "Trámites"
            case .mapaCiudad: return "Mapa"
            case .ajustes: return "Ajustes"
            }
        }
    

    
    var iconName: String {
        switch self {
        case .servicios: return "nav_servicios"
        case .tramites: return "nav_tramites"
        case .mapaCiudad: return "nav_mapa"
        case .ajustes: return "nav_ajustes"
        }
    }
}
