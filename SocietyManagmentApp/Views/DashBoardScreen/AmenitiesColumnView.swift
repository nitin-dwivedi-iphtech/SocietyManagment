//
//  AmenitiesColumnView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
import CoreData

struct AmenitiesColumnView: View {
    @ObservedObject var profile: Profile

    @StateObject private var viewModel = AmenitiesViewModel()

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
                    .onTapGesture {
                        viewModel.showAmenitiesSheet = true
                    }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(AmenitiesEnum.allCases) { amenity in
                        AmenitiesCardView(
                            amenity: amenity,
                            name: amenity.rawValue.capitalized,
                            slotsOpen: 8,
                            color: amenity.buttonColor(for: amenity),
                            image: amenity.image(for: amenity),
                            showAmenities: {
                                viewModel.selectedAmenityType = amenity
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $viewModel.showAmenitiesSheet) {
            NavigationStack {
                AmenitiesView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            }
        }
        .sheet(item: $viewModel.selectedAmenityType) { amenity in
            NavigationStack {
                if let matchingCoreDataAmenity = viewModel.amenities.first(where: {
                    $0.name?.lowercased() == amenity.rawValue.lowercased()
                }) {
                    AmenitiesDetailView(profile: profile, amenityType: amenity, loadedAmenity: matchingCoreDataAmenity)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.hidden)
                } else {
                    Text("Loading Amenity Details...")
                        .padding()
                }
            }
        }
    }
}

struct AmenitiesCardView: View {

    var amenity: AmenitiesEnum
    var name: String
    var slotsOpen: Int
    var color: Color
    var image: String

    @Environment(\.sizeCategory) var sizeCategory

    var showAmenities: () -> Void

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
                Text("Slots available")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .bold()
                    .lineLimit(1)

                Spacer()

                Button(action: {
                    showAmenities()
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
