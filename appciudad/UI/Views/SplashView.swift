import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            // Fondo
            Color(red: 0.06, green: 0.14, blue: 0.20) // #102334
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Logo
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 48)
                    
                    Spacer()
                }
                
                // Logo BAQ
                HStack {
                    Spacer()
                    Image("baq")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 80)
                    Spacer()
                }
                
                // Flor
                HStack {
                    Spacer()
                    Image("flor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, -40)
                        .padding(.trailing, 0)
                }
            }
        }
        .onAppear {
            // Iniciar el temporizador cuando la vista aparece
            viewModel.startSplash()
        }
        .onReceive(viewModel.$isSplashFinished) { finished in
            if finished {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            MainTabView()
        }
    }
}

#Preview {
    SplashView()
}
