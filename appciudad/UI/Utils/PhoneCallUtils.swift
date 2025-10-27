import UIKit

class PhoneCallUtils {
    
    // Abre la aplicación de teléfono con el número especificado
    static func makePhoneCall(to phoneNumber: String) {
        // Limpieza del número de espacios y caracteres especiales
        let cleanedNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        // Se crea la url para hacer la llamada
        guard let phoneURL = URL(string: "tel://\(cleanedNumber)") else {
            print("Error: No se pudo crear la URL para el número: \(phoneNumber)")
            return
        }
        
        // Se verificar si el dispositivo puede hacer llamadas
        guard UIApplication.shared.canOpenURL(phoneURL) else {
            print("Error: El dispositivo no puede hacer llamadas telefónicas")
            return
        }
        
        print("Abriendo aplicación de teléfono para marcar: \(cleanedNumber)")
        
        // Abrir la aplicación de teléfono
        UIApplication.shared.open(phoneURL) { success in
            if success {
                print("Aplicación de teléfono abierta correctamente")
            } else {
                print("Error: No se pudo abrir la aplicación de teléfono")
            }
        }
    }
    
    // Método para marcar el número 195
    static func call195() {
        print("Iniciando llamada a línea de emergencia 195")
        makePhoneCall(to: "195")
    }
}
