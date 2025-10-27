import Foundation

/// Modelo para mostrar alertas en la UI.
struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
