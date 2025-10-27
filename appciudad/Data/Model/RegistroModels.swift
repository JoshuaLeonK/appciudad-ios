import Foundation

struct RegistroValidacionRequest: Codable {
    let fecha: String
    
    enum CodingKeys: String, CodingKey {
        case fecha
    }
}

struct RegistroValidacionResponse: Codable {
    let success: Bool
    let message: String?
    let preguntas: [String]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case preguntas
    }
}

struct RegistroUsuario {
    let numeroIdentificacion: String
    let fechaExpedicion: Date
    
    var fechaExpedicionFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: fechaExpedicion)
    }
    
    var fechaExpedicionISO: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: fechaExpedicion)
    }
}

struct RegistroResult: Identifiable {
    let id = UUID()
    let message: String
    let preguntas: [String]
    
    init(message: String, preguntas: [String]) {
        self.message = message
        self.preguntas = preguntas
    }
}

enum RegistroValidacionState {
    case idle
    case loading
    case success(RegistroResult)
    case error(String)
}

enum RegistroOpcionesState {
    case idle
    case preguntaSeleccionada(String)
    case navegarAMain
}
