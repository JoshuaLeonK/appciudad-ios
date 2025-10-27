import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("fondo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                Color.splashBackground.opacity(0.65)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header con logo BAQ
                        VStack(spacing: 20) {
                            Image("baq")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 140, height: 140)
                                )
                            
                            Text("ACERCA DE LA APP")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        
                        // Información de la app
                        VStack(spacing: 20) {
                            InfoCard(
                                icon: "info.circle.fill",
                                title: "Versión",
                                description: "1.0.0"
                            )
                            
                            InfoCard(
                                icon: "building.2.fill",
                                title: "Desarrollado por",
                                description: "Alcaldía de Barranquilla"
                            )
                            
                            InfoCard(
                                icon: "calendar.badge.clock",
                                title: "Última actualización",
                                description: "Septiembre 2025"
                            )
                            
                            InfoCard(
                                icon: "heart.fill",
                                title: "Propósito",
                                description: "Conectar a los ciudadanos con los servicios municipales de manera fácil y eficiente"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
}

#Preview {
    AboutView()
}
