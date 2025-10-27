import SwiftUI

struct IdentificacionRptView: View {
    let funcionario: FuncionarioData
    @State private var showPulseChat = false
    
    var body: some View {
        ZStack {
            // Fondo con imagen
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Capa semi transparente
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con franja azul y logo
                headerView
                
                // Contenido principal
                ScrollView {
                    VStack(spacing: 20) {
                        // Título
                        Text("Información del Funcionario")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 32)
                        
                        // Foto del funcionario
                        if let imageUrl = funcionario.image, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                                    .shadow(radius: 5)
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        ProgressView()
                                    )
                            }
                            .padding(.bottom, 8)
                        }
                        
                        // Campos de información
                        VStack(spacing: 20) {
                            // 1. Nombre
                            if let nombre = funcionario.nombre {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Nombre:")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text(nombre)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.3))
                                )
                            }
                            
                            // 2. Documento
                            if let doc = funcionario.doc {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Documento:")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text(doc)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.3))
                                )
                            }
                            
                            // 6. Vigencia
                            if let fechaVigencia = funcionario.fechaVigencia {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Vigencia:")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text(fechaVigencia)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.3))
                                )
                            }
                            
                            // 4. Entidad
                            if let entidad = funcionario.entidad {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Entidad:")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text(entidad)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.3))
                                )
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 120)
                    }
                }
                
                Spacer()
            }
            
            // Botón flotante de ayuda
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showPulseChat = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Image("ayuda")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 60)
                }
            }
            
            // Navbar inferior
            VStack {
                Spacer()
                CustomBottomNavigationView(
                    selectedTab: Binding(
                        get: { .servicios },
                        set: { _ in }
                    ),
                    onTabSelected: { tab in
                        // Cerrar IdentificacionRptView
                        NotificationCenter.default.post(name: Notification.Name("DismissIdentificacionRptView"), object: nil)
                        NotificationCenter.default.post(
                            name: NSNotification.Name("NavigateToMainTab"),
                            object: tab
                        )
                    },
                    allowNoneSelected: true
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .pulseChatOverlay(isPresented: $showPulseChat)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 0) {
            // Franja azul con logo
            ZStack {
                Color(hex: "#102334")
                    .frame(height: 75)
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding(.vertical, 12)
            }
            .padding(.top, 32)
        }
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#102334").opacity(0.7))
            
            Text(value)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(hex: "#102334"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    IdentificacionRptView(
        funcionario: FuncionarioData(
            idUsuario: 37497,
            nombre: "Ruben Alberto Cortes Caro",
            image: "https://funcionariosbaq.s3.amazonaws.com/1140873991.png",
            tipoSangre: "O+",
            doc: "1140873991",
            dependencia: "Gerencia TIC",
            fechaVigencia: "2025-12-31",
            entidad: "Alcaldia de Barranquilla"
        )
    )
}


