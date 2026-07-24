//
//  AmenitiesViewModel.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 24/07/26.
//

import SwiftUI
import CoreData

@Observable
class AmenitiesViewModel{
    var amenities: [Amenities] = []
    var activeBookings: [Bookings] = []
    var selectedDate: Date = Date()
    var selectedSlot: String?
    var showAmenitiesSheet: Bool = false
    var selectedAmenityType: AmenitiesEnum?

    private let viewContext: NSManagedObjectContext
    var bookingVM: BookingViewModel?

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchAmenities()
        fetchActiveBookings()
    }

    func fetchAmenities() {
        let request: NSFetchRequest<Amenities> = NSFetchRequest(entityName: "Amenities")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Amenities.name, ascending: true)]
        amenities = (try? viewContext.fetch(request)) ?? []
    }

    func fetchActiveBookings() {
        let request: NSFetchRequest<Bookings> = NSFetchRequest(entityName: "Bookings")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Bookings.bookingDate, ascending: true)]
        request.predicate = NSPredicate(format: "isExpired == false")
        activeBookings = (try? viewContext.fetch(request)) ?? []
    }

    func dynamicSlots(amenityId: UUID?) -> [(slot: StandardSlots, count: Int)] {
        StandardSlots.allCases.map { time in
            let count = currentBookingsCount(for: time, on: selectedDate, amenityId: amenityId)
            return (slot: time, count: count)
        }
    }

    func currentBookingsCount(for slot: StandardSlots, on date: Date, amenityId: UUID?) -> Int {
        let calendar = Calendar.current
        let targetHour = slot.getTargetHour()
        return activeBookings.filter { booking in
            guard let bDate = booking.bookingDate else { return false }
            let isSameDay = calendar.isDate(bDate, inSameDayAs: date)
            let bookingHour = calendar.component(.hour, from: bDate)
            let isSameHour = bookingHour == targetHour
            let isMatchingAmenity = booking.amenityId == amenityId
            return isSameDay && isSameHour && isMatchingAmenity
        }.count
    }

    func createBooking(profile: Profile, amenity: Amenities, slotId: String) {
        guard let slotEnum = StandardSlots.allCases.first(where: { $0.id == slotId }) else { return }

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
        booking.amenityId = amenity.id
        booking.booking_amenities_relation = amenity
        booking.profileId = profile.id
        booking.booking_profile_relation = profile

        viewContext.saveData()
        fetchActiveBookings()
        bookingVM?.fetchBookings()

        let amenityName = amenity.name ?? "Amenity"
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

    func resetSelectedDate() {
        selectedSlot = nil
    }
}
