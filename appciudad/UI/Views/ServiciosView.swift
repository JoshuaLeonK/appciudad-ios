import SwiftUI

struct ServiciosView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var showHelpOverlay = false // Estado para el overlay de ayuda
    
    // Grid a 3 columnas
    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("fondo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            MainHeaderView()
                            
                            // Grid de servicios
                            LazyVGrid(columns: gridColumns, spacing: 0) {
                                ForEach(viewModel.services) { service in
                                    ServiceGridItem(service: service) {
                                        viewModel.onServiceTapped(service)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                            .padding(.bottom, 100) // Espacio para la navbar
                        }
                    }
                    
                    Spacer()
                }
                
                // Botón flotante MÁS GRANDE - AJUSTES APLICADOS AQUÍ
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button(action: {
                                                    withAnimation {
                                                        showHelpOverlay = true
                                                    }
                                                }) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color.white)
                                                            .frame(width: 80, height: 80)
                                                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                                        
                                                        Image("ayuda")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 50, height: 50)
                                                    }
                                                }
                                                .padding(.trailing, 16)
                                                .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(viewModel.$selectedService) { service in
            if let service = service {
                print("Navegando a: \(service.title)")
            }
        }
        .helpOverlay(isPresented: $showHelpOverlay)
    }
}

#Preview("Servicios") {
    ServiciosView()
}

#Preview("Tramites") {
    TramitesView()
}

#Preview("Mapa Ciudad") {
    MapaCiudadView()
}

#Preview("Settings") {
    SettingsView()
}
