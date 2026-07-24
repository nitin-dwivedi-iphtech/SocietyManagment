//
//  ContentView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @AppStorage("selectedTheme") private var selectedTheme: Int = 1
    private var dashboardVM = DashboardViewModel()
    private var visitorVM = VisitorViewModel()
    private var complaintVM = ComplaintViewModel()
    private var maintenanceVM = MaintenanceViewModel()
    private var amenitiesVM = AmenitiesViewModel()
    private var noticesVM = NoticesViewModel()
    private var bookingVM = BookingViewModel()
    private var profileVM = ProfileViewModel()

    @State var selectedTabView: Int = 2

    private var preferredScheme: ColorScheme? {
        switch selectedTheme {
        case 1: return .light
        case 2: return .dark
        default: return .none
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $selectedTabView) {
                if let profile = dashboardVM.profile {

                    // Visitor
                    NavigationView {
                        VisitorView()
                    }
                    .tabItem {
                        Label("Visitor", systemImage: "ticket.fill")
                    }
                    .tag(0)

                    // Complaints
                    NavigationView {
                        ComplaintView(profileId: profile.id ?? UUID())
                    }
                    .tabItem {
                        Label("Complaints", systemImage: "exclamationmark.bubble.fill")
                    }
                    .tag(1)

                    // DashBoard
                    NavigationStack {
                        DashBoardView(selectedTabView: $selectedTabView)
                    }
                    .navigationBarHidden(false)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(2)

                    // Maintenance
                    NavigationView {
                        MaintenanceView()
                    }
                    .tabItem {
                        Label("Pay", systemImage: "creditcard.fill")
                    }
                    .tag(3)

                    // Profile
                    NavigationView {
                        ProfileView()
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
        .environment(dashboardVM)
        .environment(visitorVM)
        .environment(complaintVM)
        .environment(maintenanceVM)
        .environment(amenitiesVM)
        .environment(noticesVM)
        .environment(bookingVM)
        .environment(profileVM)
        .onAppear {
            amenitiesVM.bookingVM = bookingVM
        }
    }
}

#Preview {
    ContentView()
}
