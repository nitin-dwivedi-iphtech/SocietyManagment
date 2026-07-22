//
//  ProfileHeaderView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    @AppStorage("selectedTheme") private var selectedTheme: Int = 0
    
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
            Button(action: toggleTheme) {
                Image(systemName: themeIcon)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
    private func toggleTheme() {
        withAnimation { if selectedTheme == 0 {
            selectedTheme = 1
        }
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

