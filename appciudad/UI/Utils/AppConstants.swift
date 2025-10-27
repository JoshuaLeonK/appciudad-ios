import Foundation

struct AppConstants {
    
    struct API {
        static let baseURL = "https://appciudad.barranquilla.gov.co/v1/api/general/"
        static let accessToken = "Token.eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJzb2Z0dGVrSldUIiwic3ViIjoie1wiY29kaWdvVXN1YXJpb1wiOjEsXCJub21icmVzVXN1YXJpb1wiOlwiUmFmYWVsIERhdmlkXCIsXCJhcGVsbGlkb3NVc3VhcmlvXCI6XCJDYXJyYXNjYWwgUMOpcmV6XCIsXCJjb3JyZW9FbGVjdHJvbmljb1wiOlwicmNhcnJhc2NhbEBiYXJyYW5xdWlsbGEuZ292LmNvXCIsXCJlc3RhZG9Vc3VhcmlvXCI6XCJBXCIsXCJjb2RpZ29EZXBlbmRlbmNpYVwiOjEwLFwibm9tYnJlRGVwZW5kZW5jaWFcIjpcIlNlY3JldGFyw61hIEdlbmVyYWwgZGVsIERpc3RyaXRvXCIsXCJjb2RpZ29BcmVhXCI6MixcIm5vbWJyZUFyZWFcIjpcIlNlY3JldGFyaWEgR2VuZXJhbFwiLFwibm9tYnJlVGlwb1wiOlwiQ1wiLFwibnVtZXJvRG9jdW1lbnRvXCI6XCI3MzIwNDYwNVwiLFwiZXNBZG1pbmlzdHJhZG9yXCI6dHJ1ZX0iLCJhdXRob3JpdGllcyI6WyJBRE1JTiJdLCJpYXQiOjE3NDQyMzM4MTksImV4cCI6MTc0NDI0MTAxOX0.M6Se2kCk1drMdMQVB8GSd5_U9OjV87jaXJRrsxhZUqtCeLALX7DdtMDJU5aXaCWvxXui3a954yC1RTZCTbXZZA"
        static let timeoutInterval: TimeInterval = 30.0
    }
    
    struct UserDefaultsKeys {
        static let authToken = "auth_token"
        static let userData = "user_data"
        static let isFirstLaunch = "is_first_launch"
        static let lastLoginDate = "last_login_date"
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 25
        static let buttonHeight: CGFloat = 50
        static let horizontalPadding: CGFloat = 32
        static let verticalSpacing: CGFloat = 16
        
        // Duraciones de animación
        static let shortAnimationDuration: Double = 0.2
        static let mediumAnimationDuration: Double = 0.4
        static let longAnimationDuration: Double = 0.6
    }
    
    struct Validation {
        static let minIdentificationLength = 6
        static let minPasswordLength = 4
        static let maxIdentificationLength = 20
        static let maxPasswordLength = 50
    }
    
    struct Images {
        static let background = "fondo"
        static let logo = "logo"
        static let help = "ayuda"
        
        // Imagenes temporales
        static let personCircleFill = "person.circle.fill"
        static let lockFill = "lock.fill"
        static let eyeSlashFill = "eye.slash.fill"
        static let eyeFill = "eye.fill"
    }
    
    struct Text {
        struct Login {
            static let title = "INICIO"
            static let identificationLabel = "Número de identificación:"
            static let identificationPlaceholder = "Ingresa tu número de identificación"
            static let passwordLabel = "Contraseña:"
            static let passwordPlaceholder = "Ingresa tu contraseña"
            static let loginButton = "INICIAR"
            static let loadingButton = "CARGANDO..."
            static let cancelButton = "Cancelar"
        }
        
        struct Alerts {
            static let success = "Éxito"
            static let error = "Error"
            static let warning = "Advertencia"
            static let invalidData = "Datos Inválidos"
            static let connectionError = "Error de Conexión"
            static let ok = "OK"
        }
    }
}

extension AppConstants {
    /// Verifica si es la primera vez que se ejecuta la app
    static var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstLaunch)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: UserDefaultsKeys.isFirstLaunch)
        }
    }
    
    /// Se obtiene el token de autenticación
    static var savedAuthToken: String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.authToken)
    }
    
    /// Se obtienen los datos del usuario
    static var savedUserData: Usuario? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.userData) else { return nil }
        return try? JSONDecoder().decode(Usuario.self, from: data)
    }
}
