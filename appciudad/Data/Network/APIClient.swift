import Foundation

/// Cliente base para realizar peticiones HTTP
class APIClient {
    static let shared = APIClient()
    
    private let session: URLSession
    private let baseURL = "https://appciudad.barranquilla.gov.co/v1/api/general/"
    private let accessToken = "Token.eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJzb2Z0dGVrSldUIiwic3ViIjoie1wiY29kaWdvVXN1YXJpb1wiOjEsXCJub21icmVzVXN1YXJpb1wiOlwiUmFmYWVsIERhdmlkXCIsXCJhcGVsbGlkb3NVc3VhcmlvXCI6XCJDYXJyYXNjYWwgUMOpcmV6XCIsXCJjb3JyZW9FbGVjdHJvbmljb1wiOlwicmNhcnJhc2NhbEBiYXJyYW5xdWlsbGEuZ292LmNvXCIsXCJlc3RhZG9Vc3VhcmlvXCI6XCJBXCIsXCJjb2RpZ29EZXBlbmRlbmNpYVwiOjEwLFwibm9tYnJlRGVwZW5kZW5jaWFcIjpcIlNlY3JldGFyw61hIEdlbmVyYWwgZGVsIERpc3RyaXRvXCIsXCJjb2RpZ29BcmVhXCI6MixcIm5vbWJyZUFyZWFcIjpcIlNlY3JldGFyaWEgR2VuZXJhbFwiLFwibm9tYnJlVGlwb1wiOlwiQ1wiLFwibnVtZXJvRG9jdW1lbnRvXCI6XCI3MzIwNDYwNVwiLFwiZXNBZG1pbmlzdHJhZG9yXCI6dHJ1ZX0iLCJhdXRob3JpdGllcyI6WyJBRE1JTiJdLCJpYXQiOjE3NDQyMzM4MTksImV4cCI6MTc0NDI0MTAxOX0"
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: config)
    }
    
    /// Realiza una petición POST genérica
    func post<T: Codable, U: Codable>(
        endpoint: String,
        requestBody: T,
        responseType: U.Type
    ) async throws -> U {
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "x-access-token")
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknownError
            }
            
            // Verificar código de respuesta HTTP
            switch httpResponse.statusCode {
            case 200...299:
                // Respuesta exitosa
                break
            case 401:
                throw NetworkError.invalidCredentials
            case 400...499:
                throw NetworkError.serverError(httpResponse.statusCode, "Error del cliente")
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode, "Error del servidor")
            default:
                throw NetworkError.serverError(httpResponse.statusCode, "Código de respuesta inesperado")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch {
            if error is NetworkError {
                throw error
            } else if error is URLError {
                let urlError = error as! URLError
                switch urlError.code {
                case .timedOut:
                    throw NetworkError.connectionTimeout
                case .notConnectedToInternet, .networkConnectionLost:
                    throw NetworkError.networkError(error)
                default:
                    throw NetworkError.networkError(error)
                }
            } else {
                throw NetworkError.unknownError
            }
        }
    }
}
