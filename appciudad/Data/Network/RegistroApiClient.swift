import Foundation
import Combine

protocol RegistroApiClientProtocol {
    func validarFecha(_ request: RegistroValidacionRequest) -> AnyPublisher<RegistroValidacionResponse, Error>
}

class RegistroApiClient: RegistroApiClientProtocol {
    
    private static let baseURL = "https://appciudad.barranquilla.gov.co/v1/api/general/fecha"
    private static let accessToken = "Token.eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJzb2Z0dGVrSldUIiwic3ViIjoie1wiY29kaWdvVXN1YXJpb1wiOjEsXCJub21icmVzVXN1YXJpb1wiOlwiUmFmYWVsIERhdmlkXCIsXCJhcGVsbGlkb3NVc3VhcmlvXCI6XCJDYXJyYXNjYWwgUMOpcmV6XCIsXCJjb3JyZW9FbGVjdHJvbmljb1wiOlwicmNhcnJhc2NhbEBiYXJyYW5xdWlsbGEuZ292LmNvXCIsXCJlc3RhZG9Vc3VhcmlvXCI6XCJBXCIsXCJjb2RpZ29EZXBlbmRlbmNpYVwiOjEwLFwibm9tYnJlRGVwZW5kZW5jaWFcIjpcIlNlY3JldGFyw61hIEdlbmVyYWwgZGVsIERpc3RyaXRvXCIsXCJjb2RpZ29BcmVhXCI6MixcIm5vbWJyZUFyZWFcIjpcIlNlY3JldGFyaWEgR2VuZXJhbFwiLFwibm9tYnJlVGlwb1wiOlwiQ1wiLFwibnVtZXJvRG9jdW1lbnRvXCI6XCI3MzIwNDYwNVwiLFwiZXNBZG1pbmlzdHJhZG9yXCI6dHJ1ZX0iLCJhdXRob3JpdGllcyI6WyJBRE1JTiJdLCJpYXQiOjE3NDQyMzM4MTksImV4cCI6MTc0NDI0MTAxOX0.uY_HgFdmtK4BGXG8vXM8DFh5f5wGZLvAPJK"
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    func validarFecha(_ request: RegistroValidacionRequest) -> AnyPublisher<RegistroValidacionResponse, Error> {
        print("ApiClient: Iniciando llamada API...")
        
        guard let url = URL(string: Self.baseURL) else {
            return Fail(error: RegistroApiError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(Self.accessToken, forHTTPHeaderField: "x-access-token")
        
        do {
            let encoder = JSONEncoder()
            urlRequest.httpBody = try encoder.encode(request)
            print("ApiClient: Request body: \(String(data: urlRequest.httpBody!, encoding: .utf8) ?? "nil")")
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                print("ApiClient: Respuesta recibida")
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RegistroApiError.invalidResponse
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    print("ApiClient: Error del servidor - código: \(httpResponse.statusCode)")
                    throw RegistroApiError.serverError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: RegistroValidacionResponse.self, decoder: decoder)
            .mapError { error -> Error in
                print("ApiClient: Error: \(error)")
                if error is DecodingError {
                    return RegistroApiError.decodingError
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}

enum RegistroApiError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .serverError(let code):
            return "Error del servidor (código: \(code))"
        case .decodingError:
            return "Error procesando respuesta del servidor"
        case .noData:
            return "No se recibieron datos del servidor"
        }
    }
}
