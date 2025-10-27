import SwiftUI

struct TramitesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con franja azul y logo (igual a SettingsView)
                ZStack {
                    Rectangle()
                        .fill(Color(hex: "#102334"))
                        .frame(height: 75)
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 60)
                        .padding(.vertical, 12)
                }
                .padding(.top, 32)
                
                // Contenido principal
                ScrollView {
                    LazyVStack(spacing: 12) {
                        TramiteItem(
                            title: "Certificado de Residencia",
                            description: "Solicita tu certificado de residencia",
                            icon: "house.circle.fill"
                        )
                        
                        TramiteItem(
                            title: "Paz y Salvo Predial",
                            description: "Obtén tu paz y salvo de impuesto predial",
                            icon: "checkmark.seal.fill"
                        )
                        
                        TramiteItem(
                            title: "Licencia de Construcción",
                            description: "Solicita permisos de construcción",
                            icon: "building.2.fill"
                        )
                        
                        TramiteItem(
                            title: "Registro Mercantil",
                            description: "Trámites relacionados con comercio",
                            icon: "storefront.fill"
                        )
                        
                        TramiteItem(
                            title: "SISBEN",
                            description: "Consulta y actualización de SISBEN",
                            icon: "person.3.fill"
                        )
                        
                        TramiteItem(
                            title: "Otros Trámites",
                            description: "Ver más trámites disponibles",
                            icon: "ellipsis.circle.fill"
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
        }
    }
}

// Componente reutilizable para cada item de trámite
struct TramiteItem: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        Button(action: {
            print("Trámite seleccionado: \(title)")
            // Aquí va la navegación al trámite específico
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TramitesView()
}
