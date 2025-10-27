import SwiftUI

struct MainHeaderView: View {
    var body: some View {
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
            
            // Card con imagen baq
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.clear)
                    .frame(height: 150)
                    .overlay(
                        Image("baq3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    )
                    .cornerRadius(20)
                    .padding(.horizontal, 32)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        VStack {
            MainHeaderView()
            Spacer()
        }
    }
}
