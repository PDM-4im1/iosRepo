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

                        Text("Home")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                    // Main content area
                    VStack {
                        switch selectedMenuItem {
                        case .dashboard:
                            DashboardContentView()
                        case .profile:
                            Text("Your Profile")
                        case .settings:
                            Text("Settings")
                        case .none:
                            EmptyView()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
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
            .contentShape(Rectangle()) // Add this to make the entire content tappable
            .onTapGesture {
                withAnimation {
                    isSidebarVisible = false
                }
            }
        }
    }
}



struct SidebarView: View {
    @Binding var selectedMenuItem: MenuItem?
    var closeSidebar: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
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
                selectedMenuItem = MenuItem.profile
                closeSidebar()
            }) {
                Label("Profile", systemImage: "person.fill")
                    .foregroundColor(.white)
                    .padding()
            }

            Button(action: {
                selectedMenuItem = MenuItem.settings
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
    case profile
    case settings
    // Add more menu items as needed
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
