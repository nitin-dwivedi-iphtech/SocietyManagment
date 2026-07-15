//
//  AmenitiesColumnView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI

struct AmenitiesColumnView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Amenities")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }.padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    AmenitiesCardView(name: "Gymnasium", slotsOpen: 8, color: Color.blue, image: "gym")
                    AmenitiesCardView(name: "Swimming", slotsOpen: 3, color: Color.green, image: "swiming")
                    AmenitiesCardView(name: "Club House", slotsOpen: 5, color: Color.purple, image: "club_house")
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AmenitiesCardView: View {
    var name: String
    var slotsOpen: Int
    var color: Color
    var image: String
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack(spacing: 0) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: sizeCategory.isAccessibilityCategory ? 90 : 120)
                .clipped()
                .opacity(0.8)
                .background(Color.gray.opacity(0.3))
                .overlay(alignment: .bottomLeading) {
                    Text(name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 6)
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1)
                }
            
            HStack {
                Text("\(slotsOpen) slots open")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .bold()
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: {
                    // Booking action
                }) {
                    Text("Book")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 12)
                        .foregroundColor(.white)
                        .background(color)
                        .clipShape(Capsule())
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
        }
        .frame(width: 200)
        .frame(minHeight: 170)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    AmenitiesColumnView()
        .preferredColorScheme(.dark)
}
