//
//  ContentView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct ContentView: View {
    
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
    
    @State var selectedTabView:Int = 2
    
    var body: some View {
        let validProfile = profiles.first
        
        TabView(selection: $selectedTabView){
            if let profile = validProfile{

                // Visitor
                NavigationView{
                    VisitorView(visitors: visitors)
                }
                .tabItem{
                    Label("Visitor",systemImage: "ticket.fill")
                }
                .tag(0)
                
                // Complaints
                NavigationView{
                    ComplaintView(profile: profile, complaints: complaints)
                }
                .tabItem{
                    Label("Complaints", systemImage: "exclamationmark.bubble.fill")
                }
                .tag(1)
                
                
                // DashBoard
                NavigationView{
                    DashBoardView(profile: profile, selectedTabView:$selectedTabView)
                }
                
                .navigationBarHidden(false)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(2)
                    
                // Maintenance
                NavigationView{
                    MaintenanceView(maintenances: maintenances, profile: profile)
                }
                .tabItem{
                    Label("Pay", systemImage: "creditcard.fill")
                }
                .tag(3)
                
                // Profile
                NavigationView{
                    ProfileView(profile: profile)
                }
                .tabItem{
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
            }
            else{
                Text("Loading")
            }
        }
    }
}

#Preview {
    ContentView()
}
