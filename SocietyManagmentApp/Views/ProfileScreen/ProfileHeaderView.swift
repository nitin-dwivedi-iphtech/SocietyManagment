//
//  ProfileHeaderView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    var bookMarkTap: ()->Void
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4) {
                Text("My Profile")
                    .font(.title)
                    .bold()
                
                Text("Resident Details & Security Info")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                
            }
            Spacer()
            Image(systemName: "bookmark.fill")
                .frame(width: 80,height: 80)
                .onTapGesture {
                    bookMarkTap()
                }
        }
    }
}

    //#Preview {
    //    ProfileHeaderView()
    //}
