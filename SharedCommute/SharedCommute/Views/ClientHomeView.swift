
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
        
              
            case .delivery:
             Text("delivery")
          
            case.editInfo:
                Text("edit")
            case.logOut:
                Text("logout")
            case.search:
                ClientMappingView(internalsource: .constant(""), internaldestination: .constant(""), selectedHoursMapping: .constant(0), selectedMinutesMapping: .constant(0), initialidcovoiturage: .constant(""))
            case.emergency:
                Text("emrgency")
            case.history:
                Text("history")
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
    
    @State private var isSettingsSubmenuExpanded = false
    @State private var isCarpoolingSubmenuExpanded = false
    
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
                    
                    isCarpoolingSubmenuExpanded.toggle()
                }) {
                    HStack {
                        Label("Carpooling", systemImage: "car.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                        
                        Image(systemName: isCarpoolingSubmenuExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                            .font(.body)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.6))
                    )
                }
                
                if isCarpoolingSubmenuExpanded {
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            selectedMenuItem = MenuClientItem.search
                            closeSidebar()
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                                Text("Search")
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 30)
                        }
                        .animation(.easeOut(duration: 0.2))
                        
                        Button(action: {
                            selectedMenuItem = MenuClientItem.history
                            closeSidebar()
                        }) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                Text("History")
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 30)
                        }
                        .animation(.easeOut(duration: 0.2))
                        
                        Button(action: {
                            selectedMenuItem = MenuClientItem.emergency
                            closeSidebar()
                        }) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.white)
                                Text("Emergency")
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 30)
                        }
                        .animation(.easeOut(duration: 0.2))
                    }
                }
                
                Button(action: {
                    isSettingsSubmenuExpanded.toggle()
                }) {
                    HStack {
                        Label("Settings", systemImage: "gearshape.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                        
                        Image(systemName: isSettingsSubmenuExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                            .font(.body)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.6))
                    )
                }
                
                if isSettingsSubmenuExpanded {
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            selectedMenuItem = MenuClientItem.editInfo
                            closeSidebar()
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                Text("Edit Info")
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 30)
                        }
                        .animation(.easeOut(duration: 0.2))
                        
                        Button(action: {
                            selectedMenuItem = MenuClientItem.logOut
                            closeSidebar()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.white)
                                Text("Log Out")
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 30)
                        }
                        .animation(.easeOut(duration: 0.2))
                    }
                }
                Spacer()

            }
            .navigationBarHidden(true)
        }
    }
}

struct SubmenuOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
enum MenuClientItem {
    case dashboard
    case delivery
    case editInfo
    case logOut
    case search
    case history
    case emergency
    // Add more menu items as needed
}
struct ClientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ClientHomeView()
    }
}
