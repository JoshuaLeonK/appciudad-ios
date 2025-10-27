import SwiftUI
import MapKit

struct MapaCiudadView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MapaCiudadViewModel()
    
    var body: some View {
        ZStack {
            // Mapa principal
            Map(coordinateRegion: $viewModel.region,
                annotationItems: viewModel.pointsOfInterest) { poi in
                MapAnnotation(coordinate: poi.coordinate) {
                    PointOfInterestMarker(poi: poi)
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con franja azul y logo (igual a TramitesView)
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
                
                Spacer()
                
                // Panel inferior con categorías (sin reservar espacio para navbar)
                VStack(spacing: 0) {
                    // Indicador de arrastre
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                    
                    // Categorías de lugares
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: viewModel.selectedCategory == category,
                                    onTap: { viewModel.selectCategory(category) }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 16)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            viewModel.loadPointsOfInterest()
        }
    }
}

// ViewModel para el mapa
@MainActor
class MapaCiudadViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.9639, longitude: -74.7964), // Barranquilla
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var pointsOfInterest: [PointOfInterest] = []
    @Published var selectedCategory: String = "Todos"
    
    let categories = ["Todos", "Gobierno", "Salud", "Educación", "Transporte", "Turismo"]
    
    func loadPointsOfInterest() {
        pointsOfInterest = [
            PointOfInterest(
                name: "Alcaldía de Barranquilla",
                category: "Gobierno",
                coordinate: CLLocationCoordinate2D(latitude: 10.9685, longitude: -74.7813),
                description: "Sede principal de la alcaldía"
            ),
            PointOfInterest(
                name: "Hospital Universidad del Norte",
                category: "Salud",
                coordinate: CLLocationCoordinate2D(latitude: 10.9993, longitude: -74.8071),
                description: "Centro hospitalario"
            ),
            PointOfInterest(
                name: "Universidad del Norte",
                category: "Educación",
                coordinate: CLLocationCoordinate2D(latitude: 11.0187, longitude: -74.8511),
                description: "Institución educativa superior"
            ),
            PointOfInterest(
                name: "Estación Metropolitano",
                category: "Transporte",
                coordinate: CLLocationCoordinate2D(latitude: 10.9639, longitude: -74.7964),
                description: "Sistema de transporte masivo"
            ),
            PointOfInterest(
                name: "Malecón del Río",
                category: "Turismo",
                coordinate: CLLocationCoordinate2D(latitude: 10.9651, longitude: -74.7912),
                description: "Atractivo turístico"
            )
        ]
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
        // Filtrar puntos de interés según categoría
        if category == "Todos" {
            loadPointsOfInterest()
        } else {
            pointsOfInterest = pointsOfInterest.filter { $0.category == category }
        }
    }
    
    func centerOnUserLocation() {
        // Centrar en Barranquilla
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 10.9639, longitude: -74.7964),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
}

// Modelo para puntos de interés
struct PointOfInterest: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let coordinate: CLLocationCoordinate2D
    let description: String
}

// Marcador personalizado para el mapa
struct PointOfInterestMarker: View {
    let poi: PointOfInterest
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: iconForCategory(poi.category))
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(colorForCategory(poi.category))
                .clipShape(Circle())
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10))
                .foregroundColor(colorForCategory(poi.category))
                .offset(y: -2)
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "Gobierno": return "building.columns"
        case "Salud": return "cross.fill"
        case "Educación": return "graduationcap.fill"
        case "Transporte": return "bus.fill"
        case "Turismo": return "camera.fill"
        default: return "mappin"
        }
    }
    
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Gobierno": return .blue
        case "Salud": return .red
        case "Educación": return .green
        case "Transporte": return .orange
        case "Turismo": return .purple
        default: return .gray
        }
    }
}

// Botón de categoría
struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(category)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MapaCiudadView()
}
