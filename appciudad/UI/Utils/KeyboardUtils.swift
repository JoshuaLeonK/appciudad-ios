import UIKit

// Keyboard Utilities
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Funciones globales
func hideKeyboard() {
    UIApplication.shared.endEditing()
}
