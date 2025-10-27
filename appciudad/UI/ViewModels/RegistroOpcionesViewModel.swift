import Foundation
import Combine

@MainActor
class RegistroOpcionesViewModel: ObservableObject {
    
    @Published var preguntas: [String] = []
    @Published var preguntaSeleccionada: String? = nil
    @Published var navigateToMain: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    private let registroResult: RegistroResult
    
    var isSiguienteButtonDisabled: Bool {
        preguntaSeleccionada == nil
    }
    
    /// Inicializacion
    init(registroResult: RegistroResult) {
        self.registroResult = registroResult
        self.preguntas = registroResult.preguntas
    }
    
    func onPreguntaSeleccionada(_ pregunta: String) {
        preguntaSeleccionada = pregunta
        toastMessage = "Opción seleccionada: \(pregunta)"
        showToast = true
    }
    
    func onSiguienteClicked() {
        guard preguntaSeleccionada != nil else {
            return
        }
        
        navigateToMain = true
    }
    
    func navigationHandled() {
        navigateToMain = false
    }
}
