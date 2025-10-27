import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var showPulseChat = false // Estado para el overlay de ayuda
    
    
    // Grid a 3 columnas con espaciado ajustado
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
                            
                            LazyVGrid(columns: gridColumns, spacing: 6) {
                                ForEach(viewModel.services) { service in
                                    ServiceGridItem(service: service) {
                                        viewModel.onServiceTapped(service)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .padding(.bottom, 100)
                        }
                    }
                    
                    Spacer()
                }
                
                // Botón flotante - actualizado para abrir overlay
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
                
                // NOTA: El Bottom Navigation ahora está en MainTabView
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .pulseChatOverlay(isPresented: $showPulseChat) // Agregar el overlay
        // Overlay para IdentificacionView
        .overlay(
            Group {
                if viewModel.shouldNavigateToIdentificacion {
                    IdentificacionView()
                        .transition(.opacity)
                }
            }
        )
        .onReceive(viewModel.$selectedService) { service in
            if let service = service {
                print("Navegando a: \(service.title)")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToMainTab"))) { notification in
            if let _ = notification.object as? NavigationTab {
                if viewModel.shouldNavigateToIdentificacion {
                    viewModel.shouldNavigateToIdentificacion = false
                }
            }
        }
    }
}

#Preview {
    MainView()
}
