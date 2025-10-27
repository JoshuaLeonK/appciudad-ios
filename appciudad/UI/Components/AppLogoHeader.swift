import SwiftUI

struct AppLogoHeader: View {
    var body: some View {
        // FranjaAzul
        ZStack {
            Color(red: 0.06, green: 0.14, blue: 0.20) // #102334
                .frame(height: 75)

            // Logo de la Alcaldía
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
                .padding(.vertical, 12)
        }
        .frame(height: 75)
    }
}

#Preview {
    AppLogoHeader()
}
