import Foundation

class IdentificacionAPIClient {
    static let shared = IdentificacionAPIClient()
    
    private let session: URLSession
    private let baseURL = "https://funcionarios.barranquilla.gov.co/v1/funcionario/"
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: config)
    }
    
    func consultarFuncionario(request: IdentificacionRequest) async throws -> IdentificacionResponse {
        guard let url = URL(string: baseURL + "consultarPublico") else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknownError
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499:
                throw NetworkError.serverError(httpResponse.statusCode, "Error del cliente")
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode, "Error del servidor")
            default:
                throw NetworkError.serverError(httpResponse.statusCode, "Código de respuesta inesperado")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(IdentificacionResponse.self, from: data)
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
    
    func escanearQR(token: String) async throws -> IdentificacionResponse {
        guard let url = URL(string: baseURL + "readPublico") else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let request = IdentificacionQRRequest(token: token)
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknownError
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499:
                throw NetworkError.serverError(httpResponse.statusCode, "Error del cliente")
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode, "Error del servidor")
            default:
                throw NetworkError.serverError(httpResponse.statusCode, "Código de respuesta inesperado")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(IdentificacionResponse.self, from: data)
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

