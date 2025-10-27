import Foundation

/// Errores específicos de la red y de la API
enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int, String?)
    case invalidCredentials
    case connectionTimeout
    case unknownError
    case businessError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "No se recibieron datos del servidor"
        case .decodingError(let error):
            return "Error al procesar la respuesta: \(error.localizedDescription)"
        case .networkError(let error):
            return "Error de conexión: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Error del servidor (\(code)): \(message ?? "Error desconocido")"
        case .invalidCredentials:
            return "Credenciales incorrectas"
        case .connectionTimeout:
            return "Tiempo de espera agotado"
        case .unknownError:
            return "Error desconocido"
        case .businessError(let message):
            return message
        }
    }
}
