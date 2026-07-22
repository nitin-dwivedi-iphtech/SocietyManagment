//
//  ContentView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct ContentView: View {
    
    @AppStorage("selectedTheme") private var selectedTheme: Int = 0
    
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) var profiles: FetchedResults<Profile>
    
    @FetchRequest(
        entity: Visitor.entity(),
        sortDescriptors: []
    ) var visitors: FetchedResults<Visitor>
    
    @FetchRequest(
        entity: Complaint.entity(),
        sortDescriptors: []
    ) var complaints: FetchedResults<Complaint>
    
    @FetchRequest(
        entity: Maintenance.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Maintenance.billMonth, ascending: false)]
    ) var maintenances: FetchedResults<Maintenance>
    
    @State var selectedTabView: Int = 2
    
    private var preferredScheme: ColorScheme? {
        switch selectedTheme {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
    
    var body: some View {
        let validProfile = profiles.first
        
        ZStack(alignment: .topTrailing) {
            TabView(selection: $selectedTabView) {
                if let profile = validProfile {

                    // Visitor
                    NavigationView {
                        VisitorView(visitors: visitors)
                    }
                    .tabItem {
                        Label("Visitor", systemImage: "ticket.fill")
                    }
                    .tag(0)
                    
                    // Complaints
                    NavigationView {
                        ComplaintView(profile: profile, complaints: complaints)
                    }
                    .tabItem {
                        Label("Complaints", systemImage: "exclamationmark.bubble.fill")
                    }
                    .tag(1)
                    
                    // DashBoard
                    NavigationStack {
                        DashBoardView(profile: profile, selectedTabView: $selectedTabView, maintenances: maintenances, visitors: visitors)
                    }
                    .navigationBarHidden(false)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(2)
                        
                    // Maintenance
                    NavigationView {
                        MaintenanceView(maintenances: maintenances, profile: profile)
                    }
                    .tabItem {
                        Label("Pay", systemImage: "creditcard.fill")
                    }
                    .tag(3)
                    
                    // Profile
                    NavigationView {
                        ProfileView(profile: profile)
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                    .tag(4)
                } else {
                    Text("Loading")
                }
            }
        }
        .preferredColorScheme(preferredScheme)
    }
    
    private func toggleTheme() {
        withAnimation {
            selectedTheme = (selectedTheme + 1) % 3
        }
    }
    
    private var themeIcon: String {
        switch selectedTheme {
        case 1: return "sun.max.fill"
        case 2: return "moon.fill"
        default: return "circle.dashed"
        }
    }
}

#Preview {
    ContentView()
}
