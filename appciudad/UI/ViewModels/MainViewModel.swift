import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    
    @Published var selectedTab: NavigationTab? = nil // Cambiado a opcional
    @Published var services: [ServiceItem] = []
    @Published var shouldNavigateToSettings: Bool = false
    @Published var shouldNavigateToTramites: Bool = false
    @Published var shouldNavigateToMapaCiudad: Bool = false
    @Published var shouldNavigateToServiciosInfo: Bool = false
    @Published var shouldNavigateToIdentificacion: Bool = false
    @Published var selectedService: ServiceItem?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupServices()
        observeTabChanges()
    }
    
    
    // Selección de los ítems del bottom navigation
    func onNavigationItemSelected(_ tab: NavigationTab) {
        switch tab {
        case .servicios:
            shouldNavigateToServiciosInfo = true
        case .tramites:
            shouldNavigateToTramites = true
        case .mapaCiudad:
            shouldNavigateToMapaCiudad = true
        case .ajustes:
            shouldNavigateToSettings = true
        }
        
        selectedTab = tab
    }
    
    // Manejo del tap en un servicio del grid
    func onServiceTapped(_ service: ServiceItem) {
        print("Servicio seleccionado: \(service.title)")
        
        // Detectacion del servicio 195
        if service.serviceType == .linea195 || service.title == "195" {
            print("Detectado servicio de emergencia 195")
            // Llamar directamente sin navegar
            PhoneCallUtils.call195()
            return
        }
        
        // Detectacion del servicio Identificacion
        if service.serviceType == .identificacion {
            print("Detectado servicio de Identificación")
            shouldNavigateToIdentificacion = true
            return
        }
        
        // Para otros servicios, mantener el comportamiento normal
        selectedService = service
        print("Navegando a servicio: \(service.title)")
    }
    
    // Manejo del tap en el FAB de ayuda
    func onHelpFABTapped() {
        print("FAB de ayuda presionado")
    }
    
    // Indica que la navegación fue manejada
    func navigationHandled() {
        shouldNavigateToSettings = false
        shouldNavigateToTramites = false
        shouldNavigateToMapaCiudad = false
        shouldNavigateToServiciosInfo = false
        shouldNavigateToIdentificacion = false
        selectedTab = nil // Resetea el tab seleccionado
    }
    
    private func setupServices() {
        services = [
            ServiceItem(title: "Eventos", imageName: "eventos", serviceType: .eventos),
            ServiceItem(title: "Novedades", imageName: "novedades", serviceType: .novedades),
            ServiceItem(title: "Clima", imageName: "clima", serviceType: .clima),
            ServiceItem(title: "Identificacion", imageName: "identificacion", serviceType: .identificacion),
            ServiceItem(title: "Rutas", imageName: "rutas", serviceType: .rutas),
            ServiceItem(title: "Adopcion Animal", imageName: "adopcion", serviceType: .adopcion),
            ServiceItem(title: "Transmetro", imageName: "transmetro", serviceType: .transmetro),
            ServiceItem(title: "SIBUS", imageName: "sibus", serviceType: .sibus),
            ServiceItem(title: "Directorio", imageName: "directorio", serviceType: .directorio),
            ServiceItem(title: "195", imageName: "a195", serviceType: .linea195)
        ]
    }
    
    private func observeTabChanges() {
        $selectedTab
            .sink { [weak self] tab in
                guard let self = self else { return }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
