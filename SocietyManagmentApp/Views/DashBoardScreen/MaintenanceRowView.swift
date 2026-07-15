//
//  MaintenanceRowView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI

struct MaintenanceRowView: View {
    var body: some View {
        VStack(alignment:.leading){
            HStack {
                Text("Maintenance")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            MaintenanceSubRowView()
            MaintenanceSubRowView()
            MaintenanceSubRowView()
        }
        .padding()
    }
}

struct MaintenanceSubRowView:View{
    var body: some View{
        HStack{
            Image(systemName: "creditcard.fill")
                .font(.system(size: 15))
                .padding(.trailing,5)
            VStack(alignment:.leading){
                Text("July Maintenance Due")
                    .font(.system(size: 13))
                
                Text("3000 Due by 10 July")
                    .font(.system(size: 10))
            }
            Spacer()
            Button(action:{
                
            }){
                Text("Pay")
                    .font(.system(size: 12))
                    .padding(.all,8)
                    .foregroundColor(.white)
                    .background(Color.orange,in: RoundedRectangle(cornerRadius: 10 ))
            }
        }
        .padding(.vertical)
        .padding(.horizontal,20)
        .background(Color.orange.opacity(0.12))
        .clipShape(Capsule())
    }
}

#Preview {
    MaintenanceRowView()
}
