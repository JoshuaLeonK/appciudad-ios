import Foundation
import Combine

enum RegistroUseCaseError: LocalizedError {
    case identificacionVacia
    case identificacionInvalida
    case fechaVacia
    case fechaInvalida
    case fechaFutura
    case fechaMuyAntigua
    case validacionFallida(String)
    
    var errorDescription: String? {
        switch self {
        case .identificacionVacia:
            return "Por favor, ingrese su número de identificación"
        case .identificacionInvalida:
            return "El número de identificación solo debe contener números"
        case .fechaVacia:
            return "Por favor, seleccione la fecha de expedición"
        case .fechaInvalida:
            return "Formato de fecha inválido. Usa dd/MM/yyyy"
        case .fechaFutura:
            return "La fecha de expedición no puede ser futura"
        case .fechaMuyAntigua:
            return "La fecha de expedición es muy antigua"
        case .validacionFallida(let message):
            return message
        }
    }
}

protocol RegistroUseCaseProtocol {
    func validarDatosEntrada(identificacion: String, fecha: String) throws -> RegistroUsuario
    func validarFecha(_ request: RegistroValidacionRequest) -> AnyPublisher<RegistroValidacionResponse, Error>
    func validarUsuario(_ registro: RegistroUsuario) -> AnyPublisher<RegistroResult, Error>
}

/// Implementation
class RegistroUseCase: RegistroUseCaseProtocol {
    
    private let apiClient: RegistroApiClientProtocol
    
    ///Initialization
    init(apiClient: RegistroApiClientProtocol = RegistroApiClient()) {
        self.apiClient = apiClient
    }
    
    func validarDatosEntrada(identificacion: String, fecha: String) throws -> RegistroUsuario {
        // Validarcion de la identificación
        guard !identificacion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RegistroUseCaseError.identificacionVacia
        }
        
        guard identificacion.allSatisfy({ $0.isNumber }) else {
            throw RegistroUseCaseError.identificacionInvalida
        }
        
        // Validacion de la fecha
        guard !fecha.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RegistroUseCaseError.fechaVacia
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "es_CO")
        guard let fechaExpedicion = dateFormatter.date(from: fecha) else {
            throw RegistroUseCaseError.fechaInvalida
        }
        
        // Validar que la fecha no sea futura
        if fechaExpedicion > Date() {
            throw RegistroUseCaseError.fechaFutura
        }
        
        // Validar que la fecha no sea muy antigua (más de 100 años)
        let calendar = Calendar.current
        if let fechaMinima = calendar.date(byAdding: .year, value: -100, to: Date()),
           fechaExpedicion < fechaMinima {
            throw RegistroUseCaseError.fechaMuyAntigua
        }
        
        print("UseCase: Datos validados correctamente")
        return RegistroUsuario(
            numeroIdentificacion: identificacion.trimmingCharacters(in: .whitespacesAndNewlines),
            fechaExpedicion: fechaExpedicion
        )
    }
    
    func validarFecha(_ request: RegistroValidacionRequest) -> AnyPublisher<RegistroValidacionResponse, Error> {
        return apiClient.validarFecha(request)
            .eraseToAnyPublisher()
    }
    
    func validarUsuario(_ registro: RegistroUsuario) -> AnyPublisher<RegistroResult, Error> {
        print("UseCase: Iniciando validación de usuario con API")
        let request = RegistroValidacionRequest(fecha: registro.fechaExpedicionISO)
        
        return apiClient.validarFecha(request)
            .tryMap { response -> RegistroResult in
                print("UseCase: Respuesta API recibida: \(response)")
                guard response.success else {
                    throw RegistroUseCaseError.validacionFallida(response.message ?? "Validación fallida")
                }
                
                let message = response.message ?? "Éxito"
                let preguntas = response.preguntas ?? []
                
                return RegistroResult(message: message, preguntas: preguntas)
            }
            .eraseToAnyPublisher()
    }
}
