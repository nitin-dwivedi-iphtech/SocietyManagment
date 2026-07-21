//
//  AmenitiesDetailView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 20/07/26.
//

import SwiftUI
internal import CoreData

struct AmenitiesDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Bookings.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookings.bookingDate, ascending: true)],
        predicate: NSPredicate(format: "isExpired == false")
    ) private var activeBookings: FetchedResults<Bookings>
    
    @ObservedObject var profile:Profile
    
    @State var selectedDate: Date = Date()
    @State private var selectedSlot: String? = nil
    
    var amenityType: AmenitiesEnum
    var loadedAmenity: Amenities
    
    private var dynamicSlots: [(slot: StandardSlots, count: Int)] {
        StandardSlots.allCases.map { time in
            let count = currentBookingsCount(for: time, on: selectedDate, bookings: Array(activeBookings))
            return (slot: time, count: count)
        }
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
                                TimeSlotView(time: data.slot.id, isSelected: selectedSlot == data.slot.id)
                                
                                Text("\(data.count)/\(StandardSlots.maxCapacity) Booked")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(isFull ? .red : (selectedSlot == data.slot.id ? .blue : .secondary))
                            }
                            .disabled(isFull)
                            .opacity(isFull ? 0.4 : 1.0)
                            .onTapGesture {
                                if !isFull {
                                    if selectedSlot == data.slot.id {
                                        selectedSlot = nil
                                    } else {
                                        selectedSlot = data.slot.id
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
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal)
                .onChange(of: selectedDate) { _ in
                    selectedSlot = nil
                }
                
                Button(action: {
                    createNewBooking()
                }) {
                    Text("Book Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selectedSlot != nil ? Color.blue : Color.gray.opacity(0.5))
                        .cornerRadius(12)
                        .shadow(color: (selectedSlot != nil ? Color.blue : Color.clear).opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedSlot == nil)
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
    
    private func currentBookingsCount(for slot: StandardSlots, on date: Date, bookings: [Bookings]) -> Int {
        let calendar = Calendar.current
        let targetHour = slot.getTargetHour()
        let currentAmenityId = loadedAmenity.id
        
        return bookings.filter { booking in
            guard let bDate = booking.bookingDate else { return false }
            
            let isSameDay = calendar.isDate(bDate, inSameDayAs: date)
            let bookingHour = calendar.component(.hour, from: bDate)
            let isSameHour = bookingHour == targetHour
            let isMatchingAmenity = booking.amenityId == currentAmenityId
            
            return isSameDay && isSameHour && isMatchingAmenity
        }.count
    }
    
    private func createNewBooking() {
        guard let slotId = selectedSlot,
              let slotEnum = StandardSlots.allCases.first(where: { $0.id == slotId }) else {
            return
        }
        
        let calendar = Calendar.current
        let targetHour = slotEnum.getTargetHour()
        
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.hour = targetHour
        components.minute = 0
        components.second = 0
        
        let booking = Bookings(context: viewContext)
        booking.id = UUID()
        booking.isExpired = false
        booking.bookingDate = calendar.date(from: components)
        booking.timeSlot = slotEnum.rawValue
        booking.amenityId = loadedAmenity.id
        booking.booking_amenities_relation = loadedAmenity
        booking.profileId = profile.id
        
        viewContext.saveData()
        
        let amenityName = loadedAmenity.name ?? "Amenity"
        
        let reminderDate = booking.bookingDate?.addingTimeInterval(-10 * 60)
        
        if reminderDate ?? Date() > Date() {
            NotificationManager.shared.scheduleNotification(
                title: "Upcoming Booking Reminder!",
                body: "Your slot for \(amenityName) (\(slotEnum.rawValue)) starts in 10 minutes. It's time to head over!",
                triggerDate: reminderDate ?? Date()
            )
        }
        selectedSlot = nil
    }
}

