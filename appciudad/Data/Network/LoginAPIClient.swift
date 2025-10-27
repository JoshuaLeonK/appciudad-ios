import Foundation

/// Protocolo para el cliente de login
protocol LoginAPIClientProtocol {
    func login(numeroIdentificacion: String, contrasena: String) async throws -> LoginResponse
}

/// Cliente específico para operaciones de login
class LoginAPIClient: LoginAPIClientProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    /// Realiza el login del usuario
    func login(numeroIdentificacion: String, contrasena: String) async throws -> LoginResponse {
        let loginRequest = LoginRequest(
            numeroIdentificacion: numeroIdentificacion,
            contrasena: contrasena
        )
        
        do {
            let response = try await apiClient.post(
                endpoint: "", // Endpoint vacío porque el baseURL ya incluye la ruta completa
                requestBody: loginRequest,
                responseType: LoginResponse.self
            )
            
            // Validación adicional del proceso
            if !response.success {
                throw NetworkError.invalidCredentials
            }
            
            return response
            
        } catch {
            // Re-lanzar el error para que el ViewModel lo maneje
            throw error
        }
    }
}
