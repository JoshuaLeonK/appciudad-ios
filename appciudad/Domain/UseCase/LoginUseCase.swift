import Foundation

/// Protocolo para el caso de uso de login
protocol LoginUseCaseProtocol {
    func execute(numeroIdentificacion: String, contrasena: String) async throws -> LoginResponse
    func validateCredentials(numeroIdentificacion: String, contrasena: String) throws
}

/// Caso de uso para manejar la lógica del proceeo  del login
class LoginUseCase: LoginUseCaseProtocol {
    private let loginAPIClient: LoginAPIClientProtocol
    
    init(loginAPIClient: LoginAPIClientProtocol = LoginAPIClient()) {
        self.loginAPIClient = loginAPIClient
    }
    
    /// Ejecuta el proceso de login completo
    func execute(numeroIdentificacion: String, contrasena: String) async throws -> LoginResponse {
        // Valida las credenciales antes de enviarlas
        try validateCredentials(numeroIdentificacion: numeroIdentificacion, contrasena: contrasena)
        
        // Realiza la petición de login
        let response = try await loginAPIClient.login(
            numeroIdentificacion: numeroIdentificacion,
            contrasena: contrasena
        )
        
        // Procesa la respuesta
        return response
    }
    
    /// Validacion de las credenciales antes de enviarlas al servidor
    func validateCredentials(numeroIdentificacion: String, contrasena: String) throws {
        let cleanedIdentificacion = numeroIdentificacion.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedContrasena = contrasena.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedIdentificacion.isEmpty {
            throw ValidationError.emptyIdentification
        }
        
        if cleanedContrasena.isEmpty {
            throw ValidationError.emptyPassword
        }
        
        // Validaciones adicionales según las reglas del proceso
        if cleanedIdentificacion.count < 6 {
            throw ValidationError.invalidIdentificationLength
        }
        
        if cleanedContrasena.count < 4 {
            throw ValidationError.invalidPasswordLength
        }
        
        // Verifica que la identificación sea numérica
        if !cleanedIdentificacion.allSatisfy({ $0.isNumber }) {
            throw ValidationError.invalidIdentificationFormat
        }
    }
}

/// Errores de validación específicos
enum ValidationError: LocalizedError {
    case emptyIdentification
    case emptyPassword
    case invalidIdentificationLength
    case invalidPasswordLength
    case invalidIdentificationFormat
    
    var errorDescription: String? {
        switch self {
        case .emptyIdentification:
            return "Por favor, ingresa su número de identificación"
        case .emptyPassword:
            return "Por favor, ingresa su contraseña"
        case .invalidIdentificationLength:
            return "El número de identificación debe tener al menos \(AppConstants.Validation.minIdentificationLength) dígitos"
        case .invalidPasswordLength:
            return "La contraseña debe tener al menos \(AppConstants.Validation.minPasswordLength) caracteres"
        case .invalidIdentificationFormat:
            return "El número de identificación debe contener solo números"
        }
    }
}
