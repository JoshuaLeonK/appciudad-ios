import Foundation
import Combine

@MainActor
class InicioViewModel: ObservableObject {
    @Published var numeroIdentificacion: String = ""
    @Published var contrasena: String = ""
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    @Published var loginSuccessful: Bool = false
    
    private let loginUseCase: LoginUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    /// Manejo del login cuando se presiona "INICIAR"
    func hacerLogin() {
        Task {
            await performLogin()
        }
    }
    
    /// Limpieza de los campos del formulario
    func clearForm() {
        numeroIdentificacion = ""
        contrasena = ""
    }
    
    /// Manejo del momento cuando se muestra una alerta
    func alertShown() {
        showAlert = false
    }
    
    /// Manejo del login es exitoso
    func loginSuccessHandled() {
        loginSuccessful = false
    }
    
    /// Ejeccion del login de forma asíncrona
    private func performLogin() async {
        // Mostrar estado de carga
        isLoading = true
        
        do {
            // Ejecutar el caso de uso
            let response = try await loginUseCase.execute(
                numeroIdentificacion: numeroIdentificacion,
                contrasena: contrasena
            )
            
            // Manejar respuesta exitosa
            handleLoginSuccess(response: response)
            
        } catch let error as ValidationError {
            // Errores de validación
            handleError(title: "Datos Inválidos", message: error.localizedDescription)
            
        } catch let error as NetworkError {
            // Errores de red
            handleError(title: "Error de Conexión", message: error.localizedDescription)
            
        } catch {
            // Otros errores
            handleError(title: "Error", message: "Ocurrió un error inesperado: \(error.localizedDescription)")
        }
        
        // Ocultar estado de carga
        isLoading = false
    }
    
    /// Manejo del éxito del login
    private func handleLoginSuccess(response: LoginResponse) {
        alertTitle = "Éxito"
        alertMessage = response.message ?? "Inicio de sesión exitoso"
        showAlert = true
        loginSuccessful = true
        
        // Limpieza del formulario después del éxito
        clearForm()
        
        if let token = response.data?.token {
            saveAuthToken(token)
        }
        
        if let usuario = response.data?.usuario {
            saveUserData(usuario)
        }
    }
    
    /// Manejo de los errores mostrando alertas
    private func handleError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    /// Guardado del token
    private func saveAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "auth_token")
        print("Token guardado: \(token)")
    }
    
    /// Guardado de los datos del usuario
    private func saveUserData(_ usuario: Usuario) {
        if let userData = try? JSONEncoder().encode(usuario) {
            UserDefaults.standard.set(userData, forKey: "user_data")
            print("Datos de usuario guardados")
        }
    }
    
    /// Indica si el botón de login debe estar habilitado
    var isLoginButtonEnabled: Bool {
        return !isLoading && !numeroIdentificacion.isEmpty && !contrasena.isEmpty
    }
    
    /// Texto del botón de login
    var loginButtonText: String {
        return isLoading ? AppConstants.Text.Login.loadingButton : AppConstants.Text.Login.loginButton
    }
}
