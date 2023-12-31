//
//  HomeView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 26/12/2023.
//
import SwiftUI
struct HomeView: View {
    @State private var isSidebarVisible = false
    @State private var selectedMenuItem: MenuItem?

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Main content
                VStack(spacing: 0) {
                    // Navigation bar with menu icon
                    MainNavigationBar(isSidebarVisible: $isSidebarVisible)

                    // Main content area
                    MainContentView(selectedMenuItem: $selectedMenuItem)
                }

                // Sidebar
                if isSidebarVisible {
                    SidebarView(selectedMenuItem: $selectedMenuItem) {
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
func handleLogout() {
        // Perform logout actions, e.g., clear user defaults
        UserDefaults.standard.removeObject(forKey: "userID")

        // Navigate to the login page
        // Note: You may need to adjust the navigation stack based on your app's structure
        // For example, assuming you have a LoginView:
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: LoginView())
            window.makeKeyAndVisible()
        }
    }
struct MainNavigationBar: View {
    @Binding var isSidebarVisible: Bool

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }) {
                Image(systemName: "list.bullet")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                    .padding()
            }

            Spacer()

                Image("logo")
                    .resizable()
                    .frame(width: 120, height: 120)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}


struct MainContentView: View {
    @Binding var selectedMenuItem: MenuItem?

    var body: some View {
        VStack {
            switch selectedMenuItem {
            case .dashboard:
                DashboardContentView()
              
            case.CarpoolingList:
                NavigationView {
                    CovoiturageListView()
                }
            case.history:
            Text("HISTORY")
            case.emergency:Text("Emergency")
            case.editInfo:
                Text("edit")
    
            case .none:
                DashboardContentView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        
    }
}


struct SidebarView: View {
    @Binding var selectedMenuItem: MenuItem?
    @State private var showingLogoutAlert = false

    var closeSidebar: () -> Void

    @State private var isSettingsSubmenuExpanded = false
    @State private var isCarpoolingSubmenuExpanded = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) { // Set alignment to .leading
                Button(action: {
                    closeSidebar()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                }

                Button(action: {
                    selectedMenuItem = MenuItem.dashboard
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
                            selectedMenuItem = MenuItem.CarpoolingList
                            closeSidebar()
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                                Text("Carpooling List")
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 30)
                        }
                        .animation(.easeOut(duration: 0.2))

                        Button(action: {
                            selectedMenuItem = MenuItem.history
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
                            selectedMenuItem = MenuItem.emergency
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
                            selectedMenuItem = MenuItem.editInfo
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
                            showingLogoutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.white)
                                Text("Log Out")
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 30)

                        }
                        .alert(isPresented: $showingLogoutAlert) {
                            Alert(
                                title: Text("Logout"),
                                message: Text("Are you sure you want to log out?"),
                                primaryButton: .default(Text("Cancel")),
                                secondaryButton: .destructive(Text("Logout")) {
                                    closeSidebar()
                                    handleLogout()
                                }
                            )
                        }
                        Spacer()
                    }
                    .animation(.easeOut(duration: 0.2))
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct DashboardContentView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Dashboard!")
                .font(.title)
                .foregroundColor(.blue)
                .padding()

            Spacer()

            // Add your dashboard content here

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

enum MenuItem {
    case dashboard
    case editInfo
    case CarpoolingList
    case history
    case emergency
    // Add more menu items as needed
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
