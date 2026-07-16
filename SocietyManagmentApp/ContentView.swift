//
//  ContentView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
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
    
    @State var selectedTabView:Int = 0
    
    var body: some View {
        let validProfile = profiles.first
        
        TabView(selection: $selectedTabView){
            if let profile = validProfile{
                
                // DashBoard
                NavigationView{
                    DashBoardView(profile: profile)
                }
                
                .navigationBarHidden(false)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
                
                // Visitor
                NavigationView{
                    VisitorView(visitors: visitors)
                }
                .tabItem{
                    Label("Visitor",systemImage: "ticket.fill")
                }
                .tag(1)
                
                // Complaints
                NavigationView{
                    ComplaintView(profile: profile, complaints: complaints)
                }
                .tabItem{
                    Label("Complaints", systemImage: "exclamationmark.bubble.fill")
                }
                .tag(2)
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
