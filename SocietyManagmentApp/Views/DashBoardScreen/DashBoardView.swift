//
//  DashBoardView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct DashBoardView: View {
    @ObservedObject var profile:Profile
    @Binding var selectedTabView:Int
    
    var body: some View {
        ScrollView{
            VStack(spacing:10){
                HStack{
                    VStack(alignment:.leading){
                        Text("GreenValley")
                            .font(.title)
                            .bold()
                        Text("Welcome back, \(profile.name ?? "N/A") 👋")
                    }.padding()
                    Spacer()
                }
                
                WelcomeCardView(userName: profile.name ?? "N/A")
                    .padding(.horizontal)
                
                
                MaintenanceRowView(selectedTabView:$selectedTabView)
                
                AmenitiesColumnView()
                
                NoticeEventsRowView()
                
                Spacer()
            }
            .padding(.all,5)
        }
    }
}



//#Preview {
//    let mockProfile = Profile()
//    mockProfile.name = "John Doe"
//   return DashBoardView(profile: mockProfile).preferredColorScheme(.dark)
//}
