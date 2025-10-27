import SwiftUI

struct MainTabView: View {
    @StateObject private var tabViewModel = MainTabNavigationViewModel()
    
    var body: some View {
        ZStack {
            // Vista principal siempre visible (MainView con grid de iconos)
            MainView()
            
            // Overlay para Ajustes para que la navbar permanezca visible
            if tabViewModel.shouldShowAjustes {
                SettingsView()
                    .transition(.opacity)
            }

            // Overlay para Trámites
            if tabViewModel.shouldShowTramites {
                TramitesView()
                    .transition(.opacity)
            }

            // Overlay para Mapa Ciudad
            if tabViewModel.shouldShowMapaCiudad {
                MapaCiudadView()
                    .transition(.opacity)
            }
            
            // Navbar inferior pegada al fondo
            VStack {
                Spacer()
                CustomBottomNavigationView(
                    selectedTab: Binding(
                        get: {
                            // Si selectedTab es nil se crea un tab temporal que no exista
                            // Esto es para que ningún botón se vea seleccionado
                            tabViewModel.selectedTab ?? .servicios
                        },
                        set: { _ in }
                    ),
                    onTabSelected: tabViewModel.onTabSelected,
                    allowNoneSelected: tabViewModel.selectedTab == nil
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(.keyboard)
        // Nota: Al seleccionar "Servicios" no se abre modal; MainView permanece visible
        // Trámites overlay lifecycle
        .onChange(of: tabViewModel.shouldShowTramites) { oldValue, newValue in
            if !newValue && oldValue {
                tabViewModel.onModalDismissed()
            }
        }
        .onChange(of: tabViewModel.shouldShowMapaCiudad) { oldValue, newValue in
            if !newValue && oldValue {
                tabViewModel.onModalDismissed()
            }
        }
        // Ajustes: ahora se muestra como overlay para mantener la navbar visible
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToMainTab"))) { notification in
            if let tab = notification.object as? NavigationTab {
                print("MainTabView recibió notificación para navegar a: \(tab.displayName)")
                tabViewModel.onTabSelected(tab)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissSettingsView"))) { _ in
            tabViewModel.shouldShowAjustes = false
            tabViewModel.onModalDismissed()
        }
    }
}

@MainActor
class MainTabNavigationViewModel: ObservableObject {
    @Published var selectedTab: NavigationTab? = nil
    @Published var shouldShowTramites: Bool = false
    @Published var shouldShowMapaCiudad: Bool = false
    @Published var shouldShowAjustes: Bool = false
    
    private var isTransitioning: Bool = false
    
    func onTabSelected(_ tab: NavigationTab) {
        guard !isTransitioning else {
            return
        }
        
        isTransitioning = true
        
        // Primero cerrar todos los modales
        resetAllModals()
        
        // Esperar un pequeño delay antes de abrir el nuevo modal
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self = self else { return }
            
            // Activar el modal correspondiente
            switch tab {
            case .servicios:
                // No abrir modal; mantener MainView visible
                // No marcar como seleccionado para que no aparezca resaltado
                self.selectedTab = nil
            case .tramites:
                self.shouldShowTramites = true
                self.selectedTab = tab
            case .mapaCiudad:
                self.shouldShowMapaCiudad = true
                self.selectedTab = tab
            case .ajustes:
                self.shouldShowAjustes = true
                self.selectedTab = tab
            }
            
            // Resetear flag después de un tiempo
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isTransitioning = false
            }
        }
    }
    
    func onModalDismissed() {
        guard !isTransitioning else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.resetAllModals()
            self?.selectedTab = nil
        }
    }
    
    private func resetAllModals() {
        shouldShowTramites = false
        shouldShowMapaCiudad = false
        shouldShowAjustes = false
    }
}

#Preview {
    MainTabView()
}
