import SwiftUI

struct VisualizationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDisplayMode: DisplayMode = .light
    @State private var textSize: Double = 1.0
    @State private var highContrast: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("fondo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                Color.splashBackground.opacity(0.65)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "eye.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            
                            Text("VISUALIZACIÓN")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 40)
                        
                        // Opciones de visualización
                        VStack(spacing: 20) {
                            // Modo de visualización
                            VisualizationSection(title: "Modo de pantalla") {
                                VStack(spacing: 12) {
                                    ForEach(DisplayMode.allCases, id: \.self) { mode in
                                        VisualizationOptionButton(
                                            title: mode.displayName,
                                            isSelected: selectedDisplayMode == mode
                                        ) {
                                            selectedDisplayMode = mode
                                        }
                                    }
                                }
                            }
                            
                            // Tamaño de texto
                            VisualizationSection(title: "Tamaño de texto") {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("A")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        
                                        Slider(value: $textSize, in: 0.8...1.5, step: 0.1)
                                            .accentColor(.white)
                                        
                                        Text("A")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("Texto de ejemplo")
                                        .font(.system(size: 16 * textSize))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                            
                            // Alto contraste
                            VisualizationSection(title: "Accesibilidad") {
                                Toggle(isOn: $highContrast) {
                                    Text("Alto contraste")
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .white))
                            }
                            
                            // Botón de aplicar cambios
                            Button(action: {
                                applyVisualizationChanges()
                            }) {
                                Text("APLICAR CAMBIOS")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func applyVisualizationChanges() {
        print("Aplicando cambios de visualización:")
        print("- Modo: \(selectedDisplayMode.displayName)")
        print("- Tamaño de texto: \(textSize)")
        print("- Alto contraste: \(highContrast)")
        
        dismiss()
    }
}

struct VisualizationSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            content
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
}

struct VisualizationOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                Color.white.opacity(isSelected ? 0.2 : 0.1)
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum DisplayMode: CaseIterable {
    case light, dark, auto
    
    var displayName: String {
        switch self {
        case .light: return "Modo claro"
        case .dark: return "Modo oscuro"
        case .auto: return "Automático"
        }
    }
}

#Preview {
    VisualizationView()
}
