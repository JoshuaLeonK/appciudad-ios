import Foundation

/// Modelo para la petición de login
struct LoginRequest: Codable {
    let numeroIdentificacion: String
    let contrasena: String
    
    enum CodingKeys: String, CodingKey {
        case numeroIdentificacion = "numero_identificacion"
        case contrasena
    }
    
    init(numeroIdentificacion: String, contrasena: String) {
        self.numeroIdentificacion = numeroIdentificacion
        self.contrasena = contrasena
    }
}
