//
//  ContentView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
import CoreData

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
    
    @State var selectedTabView:Int = 0
    
    var body: some View {
        let validProfile = profiles.first
        
        TabView(selection: $selectedTabView){
            NavigationView{
                if let profile = validProfile{
                    DashBoardView(profile: profile)
                } else{
                    Text("Loading")
                }
            }
            .navigationBarHidden(false)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationView{
                VisitorView(visitors: visitors)
            }
            .tabItem{
                Label("Visitor",systemImage: "ticket.fill")
            }
            .tag(1)
            
        }
        
    }
}

#Preview {
    ContentView()
}
