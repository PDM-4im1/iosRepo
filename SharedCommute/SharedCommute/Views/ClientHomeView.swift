
import SwiftUI
struct ClientHomeView: View {
    @State private var isSidebarVisible = false
    @State private var selectedMenuItem: MenuClientItem?

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Main content
                VStack(spacing: 0) {
                    // Navigation bar with menu icon
                    MainNavigationBar(isSidebarVisible: $isSidebarVisible)

                    // Main content area
                    MainContentClientView(selectedMenuItem: $selectedMenuItem)
                }

                // Sidebar
                if isSidebarVisible {
                    SidebarClientView(selectedMenuItem: $selectedMenuItem) {
                        withAnimation {
                            isSidebarVisible = false
                        }
                    }
                    .frame(width: min(300, UIScreen.main.bounds.width * 0.7))
                    .background(Color.gray.opacity(0.9))
                    .transition(.move(edge: .leading))
                    .onTapGesture {
                        withAnimation {
                            isSidebarVisible = false
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}



struct MainContentClientView: View {
    @Binding var selectedMenuItem: MenuClientItem?

    var body: some View {
        VStack {
            switch selectedMenuItem {
            case .dashboard:
                DashboardContentView()
            case .carpooling:
                NavigationView {
                    ClientMappingView(internalsource: .constant(""), internaldestination: .constant(""), selectedHoursMapping: .constant(0), selectedMinutesMapping: .constant(0), initialidcovoiturage: .constant(""))
                }
            case .delivery:
             Text("delivery")
            case .settings:
                Text("Settings")
            case .none:
                DashboardContentView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}


struct SidebarClientView: View {
    @Binding var selectedMenuItem: MenuClientItem?
    var closeSidebar: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                Button(action: {
                    closeSidebar()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                }

                Button(action: {
                    selectedMenuItem = MenuClientItem.dashboard
                    closeSidebar()
                }) {
                    Label("Dashboard", systemImage: "house.fill")
                        .foregroundColor(.white)
                        .padding()
                }

                Button(action: {
                    selectedMenuItem = MenuClientItem.carpooling
                    closeSidebar()
                }) {
                    Label("carpooling", systemImage: "car")
                        .foregroundColor(.white)
                        .padding()
                }
                Button(action: {
                    selectedMenuItem = MenuClientItem.carpooling
                    closeSidebar()
                }) {
                    Label("Delivery", systemImage: "car")
                        .foregroundColor(.white)
                        .padding()
                }
                Button(action: {
                    selectedMenuItem = MenuClientItem.settings
                    closeSidebar()
                }) {
                    Label("Settings", systemImage: "gearshape.fill")
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}



enum MenuClientItem {
    case dashboard
    case carpooling
    case delivery
    case settings
    // Add more menu items as needed
}

struct ClientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ClientHomeView()
    }
}
