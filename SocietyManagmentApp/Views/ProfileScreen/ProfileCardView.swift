//
//  ProfileCardView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI


struct ProfileCardView: View {
    @ObservedObject var profile: Profile
    var size: CGFloat = 64
    var firstLetter:String{
        String((profile.name as String? ?? "?").prefix(1)).uppercased()
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(firstLetter)
                .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(
                    LinearGradient(
                        colors: [.green, .emeraldGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text((profile.name as String?) ?? "Guest User")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.footnote)
                    Text("Flat \((profile.flat_no as String?) ?? "N/A")")
                        .font(.subheadline)
                }
                .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [.grandGreen, .grandBlack],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            ),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}


//#Preview {
//    ProfileCardView()
//}
