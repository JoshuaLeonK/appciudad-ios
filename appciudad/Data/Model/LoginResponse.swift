import Foundation

/// Modelo para la respuesta del API de login
struct LoginResponse: Codable {
    let success: Bool
    let message: String?
    let data: LoginData?
    
    init(success: Bool, message: String? = nil, data: LoginData? = nil) {
        self.success = success
        self.message = message
        self.data = data
    }
}

/// Datos adicionales que pueden venir en la respuesta de login
struct LoginData: Codable {
    let token: String?
    let usuario: Usuario?
}

/// Información del usuario autenticado
struct Usuario: Codable {
    let codigoUsuario: Int?
    let nombresUsuario: String?
    let apellidosUsuario: String?
    let correoElectronico: String?
    let estadoUsuario: String?
    let numeroDocumento: String?
    let esAdministrador: Bool?
    
    enum CodingKeys: String, CodingKey {
        case codigoUsuario
        case nombresUsuario
        case apellidosUsuario
        case correoElectronico
        case estadoUsuario
        case numeroDocumento
        case esAdministrador
    }
}
