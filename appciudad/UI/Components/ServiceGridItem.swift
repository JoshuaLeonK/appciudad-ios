import SwiftUI

struct ServiceGridItem: View {
    let service: ServiceItem
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) { // Distancia del título al ícono
            // Imagen con fondo circular
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(service.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
            }
            
            // Título del servicio
            Text(service.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(height: 32)
        }
        .padding(.vertical, 2) // Espacio entre filas
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 8) {
            ForEach(0..<9) { index in
                ServiceGridItem(
                    service: ServiceItem(
                        title: index == 4 ? "Adopcion Animal" : "Servicio \(index + 1)",
                        imageName: "star.fill",
                        serviceType: .eventos
                    ),
                    onTap: {}
                )
            }
        }
        .padding()
    }
}
