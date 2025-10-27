import Foundation
import Combine

@MainActor
class RegistroViewModel: ObservableObject {
    
    @Published var numeroIdentificacion: String = ""
    @Published var fechaExpedicion: String = "" // Formato dd/MM/yyyy para mostrar
    @Published var selectedDate: Date = Date()
    @Published var showDatePicker: Bool = false
    @Published var navigateToOpciones: Bool = false
    @Published var registroResult: RegistroResult?
    
    @Published private var state: RegistroValidacionState = .idle
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let message) = state {
            return message
        }
        return nil
    }
    
    var buttonTitle: String {
        isLoading ? "VALIDANDO..." : "VALIDAR"
    }
    
    var isValidarButtonDisabled: Bool {
        numeroIdentificacion.isEmpty || fechaExpedicion.isEmpty || isLoading
    }
    
    private let registroUseCase: RegistroUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(registroUseCase: RegistroUseCaseProtocol = RegistroUseCase()) {
        self.registroUseCase = registroUseCase
        setupDateObserver()
    }
    
    private func setupDateObserver() {
        $selectedDate
            .sink { [weak self] date in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                formatter.locale = Locale(identifier: "es_CO")
                self?.fechaExpedicion = formatter.string(from: date)
            }
            .store(in: &cancellables)
    }
    
    func showDatePickerAction() {
        showDatePicker = true
    }
    
    func setDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "es_CO")
        fechaExpedicion = formatter.string(from: selectedDate)
    }
    
    func validarUsuario() {
        do {
            let registro = try registroUseCase.validarDatosEntrada(
                identificacion: numeroIdentificacion,
                fecha: fechaExpedicion
            )
            
            state = .loading
            
            registroUseCase.validarUsuario(registro)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.state = .error(error.localizedDescription)
                        case .finished:
                            break
                        }
                    },
                    receiveValue: { [weak self] result in
                        self?.registroResult = result
                        self?.state = .success(result)
                        self?.navigateToOpciones = true
                    }
                )
                .store(in: &cancellables)
                
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func clearError() {
        if case .error = state {
            state = .idle
        }
    }
    
    func navigationHandled() {
        navigateToOpciones = false
    }
}
