import SwiftUI

struct SettingsHeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Franja azul con logo
            ZStack {
                // Fondo azul
                Color.splashBackground
                    .frame(height: 75)
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding(.vertical, 12)
            }
            .padding(.top, 32)
            
            Text("AJUSTES")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 32)
        }
    }
}

#Preview {
    ZStack {
        Image("fondo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
        
        Color.splashBackground.opacity(0.65)
            .ignoresSafeArea()
        
        VStack {
            SettingsHeaderView()
            Spacer()
        }
    }
}
