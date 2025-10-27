import SwiftUI

struct CustomBottomNavigationView: View {
    @Binding var selectedTab: NavigationTab
    let onTabSelected: (NavigationTab) -> Void
    var allowNoneSelected: Bool = false // Nuevo parámetro
    
    var body: some View {
        HStack {
            ForEach(Array(NavigationTab.allCases.enumerated()), id: \.offset) { index, tab in
                BottomNavigationItem(
                    tab: tab,
                    isSelected: allowNoneSelected ? false : (selectedTab == tab),
                    onTap: {
                        selectedTab = tab
                        onTabSelected(tab)
                    }
                )
                
                // Agregar barra vertical después de cada item excepto el último
                if index < NavigationTab.allCases.count - 1 {
                    Spacer()
                    
                    // Barra vertical delgada
                    Rectangle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 1, height: 40)
                        .padding(.vertical, 4)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .padding(.bottom, 0)
        .background(Color(hex: "#102334"))
        .clipShape(RoundedRectangle(cornerRadius: 0))
        .ignoresSafeArea(edges: .bottom)
        .frame(height: 60)
    }
}

struct BottomNavigationItem: View {
    let tab: NavigationTab
    let isSelected: Bool
    let onTap: () -> Void
    
    // Calcular offset según el tab
    private var horizontalOffset: CGFloat {
        switch tab {
        case .servicios:
            return 12  // 15% a la derecha
        case .ajustes:
            return -12  // 15% a la izquierda
        default:
            return 0
        }
    }
    
    var body: some View {
        Button(action: {
            NotificationCenter.default.post(
                name: NSNotification.Name("NavigateToMainTab"),
                object: tab
            )
            onTap()
        }) {
            VStack(spacing: 2) {
                Image(tab.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .scaleEffect(2.0)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                
                Text(tab.displayName)
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .background(
                isSelected ? Color.white.opacity(0.2) : Color.clear
            )
            .cornerRadius(12)
            .offset(x: horizontalOffset)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        
        CustomBottomNavigationView(
            selectedTab: .constant(.servicios),
            onTabSelected: { _ in }
        )
    }
    .background(Color.gray.opacity(0.3))
}
