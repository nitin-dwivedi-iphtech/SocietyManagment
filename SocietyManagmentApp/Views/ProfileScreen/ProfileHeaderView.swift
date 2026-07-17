//
//  ProfileHeaderView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var profile: Profile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("My Profile")
                .font(.title)
                .bold()
            
            Text("Resident Details & Security Info")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
    }
}
//
//#Preview {
//    ProfileHeaderView()
//}
