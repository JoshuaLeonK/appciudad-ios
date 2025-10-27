import Foundation
import Combine

@MainActor
class SplashViewModel: ObservableObject {
    
    @Published var isSplashFinished: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let splashDuration: TimeInterval = 2.0 // 2 segundos
    
     // Temporizador del splash screen
    func startSplash() {
        Timer.publish(every: splashDuration, on: .main, in: .common)
            .autoconnect()
            .first() // Para que se ejecute una vez
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.finishSplash()
            }
            .store(in: &cancellables)
    }
    
    private func finishSplash() {
        isSplashFinished = true
    }
    
    deinit {
        cancellables.removeAll()
    }
}

extension SplashViewModel {

    func startSplashAsync() async {
        try? await Task.sleep(nanoseconds: UInt64(splashDuration * 1_000_000_000))
        
        await MainActor.run {
            isSplashFinished = true
        }
    }
}
