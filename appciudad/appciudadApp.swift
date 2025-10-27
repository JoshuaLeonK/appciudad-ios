import SwiftUI

@main
struct AppCiudadApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(.light) // Se fuerza el modo claro en caso de que sea necesario
        }
    }
}
