import SwiftUI

struct SettingsOptionItem: View {
    let option: SettingsItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                // Icono
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Group {
                        if let _ = UIImage(named: option.iconName) {
                            Image(option.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: option.settingsType.systemIconName)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                
                // Texto de la opción
                Text(option.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Indicador de navegación
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
    }
}

struct SettingsOptionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        Color.splashBackground
            .ignoresSafeArea()
        
        VStack(spacing: 16) {
            ForEach(SettingsType.allCases, id: \.self) { type in
                SettingsOptionItem(
                    option: SettingsItem(
                        title: type.displayTitle,
                        iconName: type.iconName,
                        settingsType: type
                    ),
                    onTap: {
                        print("Tapped: \(type.displayTitle)")
                    }
                )
            }
        }
        .padding()
    }
}
