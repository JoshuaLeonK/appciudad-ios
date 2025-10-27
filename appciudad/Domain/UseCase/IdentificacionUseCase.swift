import Foundation

class IdentificacionUseCase {
    private let apiClient: IdentificacionAPIClient
    
    init(apiClient: IdentificacionAPIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func consultarFuncionario(identificacion: String, nombre: String) async throws -> IdentificacionResponse {
        let request = IdentificacionRequest(
            identificacion: identificacion,
            nombre: nombre
        )
        
        return try await apiClient.consultarFuncionario(request: request)
    }
    
    func escanearQR(token: String) async throws -> IdentificacionResponse {
        return try await apiClient.escanearQR(token: token)
    }
}

