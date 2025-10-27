import Foundation

// MARK: - Request
struct IdentificacionRequest: Codable {
    let identificacion: String
    let nombre: String
    
    enum CodingKeys: String, CodingKey {
        case identificacion
        case nombre
    }
}

// MARK: - QR Request
struct IdentificacionQRRequest: Codable {
    let token: String
}

// MARK: - Response
struct IdentificacionResponse: Codable {
    let status: Int
    let user: FuncionarioData?
    
    var isSuccess: Bool {
        return status == 201
    }
}

struct FuncionarioData: Codable {
    let idUsuario: Int?
    let nombre: String?
    let image: String?
    let tipoSangre: String?
    let doc: String?
    let dependencia: String?
    let fechaVigencia: String?
    let entidad: String?
    
    enum CodingKeys: String, CodingKey {
        case idUsuario
        case nombre
        case image
        case tipoSangre
        case doc
        case dependencia
        case fechaVigencia
        case entidad
    }
}

