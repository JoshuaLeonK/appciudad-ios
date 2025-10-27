import Foundation
import SwiftUI

@MainActor
class IdentificacionViewModel: ObservableObject {
    @Published var identificacion: String = ""
    @Published var nombres: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var funcionarioData: FuncionarioData?
    @Published var shouldShowResultView: Bool = false
    
    private let useCase: IdentificacionUseCase
    
    init(useCase: IdentificacionUseCase = IdentificacionUseCase()) {
        self.useCase = useCase
    }
    
    func buscarFuncionario() {
        // Validar campos
        guard !identificacion.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Por favor ingrese un número de identificación"
            showError = true
            return
        }
        
        guard !nombres.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Por favor ingrese los nombres"
            showError = true
            return
        }
        
        Task {
            isLoading = true
            errorMessage = nil
            showError = false
            
            do {
                let response = try await useCase.consultarFuncionario(
                    identificacion: identificacion.trimmingCharacters(in: .whitespaces),
                    nombre: nombres.trimmingCharacters(in: .whitespaces)
                )
                
                if response.isSuccess, let user = response.user {
                    funcionarioData = user
                    shouldShowResultView = true
                } else {
                    errorMessage = "No se encontró información del funcionario"
                    showError = true
                }
                
                isLoading = false
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorDescription ?? "Error desconocido"
                showError = true
            } catch {
                isLoading = false
                errorMessage = "Error al consultar la información"
                showError = true
            }
        }
    }
    
    func escanearQR(token: String) {
        Task {
            isLoading = true
            errorMessage = nil
            showError = false
            
            do {
                let response = try await useCase.escanearQR(token: token)
                
                if response.isSuccess, let user = response.user {
                    funcionarioData = user
                    shouldShowResultView = true
                } else {
                    errorMessage = "No se encontró información del funcionario"
                    showError = true
                }
                
                isLoading = false
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorDescription ?? "Error desconocido"
                showError = true
            } catch {
                isLoading = false
                errorMessage = "Error al consultar la información"
                showError = true
            }
        }
    }
    
    func clearError() {
        showError = false
        errorMessage = nil
    }
}

