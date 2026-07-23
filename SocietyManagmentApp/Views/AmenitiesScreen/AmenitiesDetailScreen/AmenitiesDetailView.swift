//
//  AmenitiesDetailView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 20/07/26.
//

import SwiftUI
import CoreData

struct AmenitiesDetailView: View {

    @Environment(\.dismiss) var dismiss

    @ObservedObject var profile: Profile

    @EnvironmentObject var viewModel: AmenitiesViewModel

    var amenityType: AmenitiesEnum
    var loadedAmenity: Amenities

    private var dynamicSlots: [(slot: StandardSlots, count: Int)] {
        viewModel.dynamicSlots(amenityId: loadedAmenity.id)
    }

    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .bottomLeading) {
                    Image(amenityType.image(for: amenityType))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .background(Color.gray.opacity(0.3))

                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(loadedAmenity.name?.capitalized ?? "Amenity")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)

                        Text("Address: Clubhouse 1st Floor • Max \(StandardSlots.maxCapacity) people/slot")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
                .frame(height: 200)
                .cornerRadius(12)
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(dynamicSlots, id: \.slot.id) { data in
                            let isFull = data.count >= StandardSlots.maxCapacity

                            VStack(spacing: 4) {
                                TimeSlotView(time: data.slot.id, isSelected: viewModel.selectedSlot == data.slot.id)

                                Text("\(data.count)/\(StandardSlots.maxCapacity) Booked")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(isFull ? .red : (viewModel.selectedSlot == data.slot.id ? .blue : .secondary))
                            }
                            .disabled(isFull)
                            .opacity(isFull ? 0.4 : 1.0)
                            .onTapGesture {
                                if !isFull {
                                    if viewModel.selectedSlot == data.slot.id {
                                        viewModel.selectedSlot = nil
                                    } else {
                                        viewModel.selectedSlot = data.slot.id
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                DatePicker(
                    "Booking Date",
                    selection: $viewModel.selectedDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal)
                .onChange(of: viewModel.selectedDate) {
                    viewModel.resetSelectedDate()
                }

                Button(action: {
                    if let slotId = viewModel.selectedSlot {
                        viewModel.createBooking(profile: profile, amenity: loadedAmenity, slotId: slotId)
                    }
                }) {
                    Text("Book Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(viewModel.selectedSlot != nil ? Color.blue : Color.gray.opacity(0.5))
                        .cornerRadius(12)
                        .shadow(color: (viewModel.selectedSlot != nil ? Color.blue : Color.clear).opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(viewModel.selectedSlot == nil)
                .padding(.horizontal)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(loadedAmenity.name?.uppercased() ?? "DETAIL")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
        }
    }
}
