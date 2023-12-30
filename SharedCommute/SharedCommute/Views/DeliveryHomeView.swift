
import SwiftUI
struct DeliverytHomeView: View {
    @State private var isSidebarVisible = false
    @State private var selectedMenuItem: MenuDeliveryItem?

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Main content
                VStack(spacing: 0) {
                    // Navigation bar with menu icon
                    MainNavigationBar(isSidebarVisible: $isSidebarVisible)

                    // Main content area
                    MainContentDeliveryView(selectedMenuItem: $selectedMenuItem)
                }

                // Sidebar
                if isSidebarVisible {
                    SidebarDeliveryView(selectedMenuItem: $selectedMenuItem) {
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



struct MainContentDeliveryView: View {
    @Binding var selectedMenuItem: MenuDeliveryItem?

    var body: some View {
        VStack {
            switch selectedMenuItem {
            case .dashboard:
                DashboardContentView()
            case .Delivery:
                Text("Delivery")

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


struct SidebarDeliveryView: View {
    @Binding var selectedMenuItem: MenuDeliveryItem?
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
                    selectedMenuItem = MenuDeliveryItem.dashboard
                    closeSidebar()
                }) {
                    Label("Dashboard", systemImage: "house.fill")
                        .foregroundColor(.white)
                        .padding()
                }

                Button(action: {
                    selectedMenuItem = MenuDeliveryItem.Delivery
                    closeSidebar()
                }) {
                    Label("Delivery", systemImage: "car")
                        .foregroundColor(.white)
                        .padding()
                }

                Button(action: {
                    selectedMenuItem = MenuDeliveryItem.settings
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



enum MenuDeliveryItem {
    case dashboard
    case Delivery
    case settings
    // Add more menu items as needed
}

struct DeliveryHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DeliverytHomeView()
    }
}
