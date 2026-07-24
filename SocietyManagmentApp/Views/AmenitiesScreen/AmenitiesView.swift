//
//  AmenitiesView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 20/07/26.
//

import SwiftUI
import CoreData

struct AmenitiesView: View {

    @Environment(AmenitiesViewModel.self) var viewModel: AmenitiesViewModel

    var profile: Profile

    var body: some View {
        List {
            ForEach(AmenitiesEnum.allCases) { amenity in
                if let processedAmenities = viewModel.amenities.first(where: {
                    $0.name?.lowercased() == amenity.rawValue.lowercased()
                }) {
                    NavigationLink(destination: AmenitiesDetailView(profile: profile, amenityType: amenity, loadedAmenity: processedAmenities)) {
                        AmenitiesRow(amenity: amenity)
                    }
                } else {
                    AmenitiesRow(amenity: amenity)
                        .opacity(0.5)
                }
            }
        }
        .navigationTitle("Amenities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AmenitiesRow: View {
    var amenity: AmenitiesEnum

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: amenity.iconName(for: amenity))
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.grandGreen.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(amenity.rawValue.capitalized)
                    .font(.body)
                    .fontWeight(.semibold)

                Text("Tap to book or view status")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
