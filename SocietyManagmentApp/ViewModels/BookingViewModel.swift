import SwiftUI
import CoreData
import Combine

class BookingViewModel: ObservableObject {
    @Published var bookings: [Bookings] = []
    @Published var amenities: [Amenities] = []
    @Published var selectedFilter: Int = 0
    @Published var selectedBooking: Bookings?
    @Published var showCancelAlert: Bool = false

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchBookings()
        fetchAmenities()
    }


    func fetchBookings() {
        let request: NSFetchRequest<Bookings> = NSFetchRequest(entityName: "Bookings")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Bookings.bookingDate, ascending: true)]
        bookings = (try? viewContext.fetch(request)) ?? []
    }

    func fetchAmenities() {
        let request: NSFetchRequest<Amenities> = NSFetchRequest(entityName: "Amenities")
        request.sortDescriptors = []
        amenities = (try? viewContext.fetch(request)) ?? []
    }


    var filteredBookings: [Bookings] {
        bookings.filter { selectedFilter == 0 ? !$0.isExpired : $0.isExpired }
    }


    func matchedAmenity(for booking: Bookings) -> Amenities? {
        guard let targetId = booking.amenityId else { return nil }
        return amenities.first(where: { $0.id == targetId })
    }

    func resolvedAmenityName(for booking: Bookings) -> String {
        matchedAmenity(for: booking)?.name ?? "Unknown Amenity"
    }

    func amenityIcon(for booking: Bookings) -> String {
        guard let name = matchedAmenity(for: booking)?.name else { return "calendar" }
        if let type = AmenitiesEnum.allCases.first(where: { $0.rawValue.lowercased() == name.lowercased() }) {
            return type.iconName(for: type)
        }
        return "calendar"
    }

    func amenityType(for booking: Bookings) -> AmenitiesEnum? {
        guard let name = matchedAmenity(for: booking)?.name else { return nil }
        return AmenitiesEnum.allCases.first(where: { $0.rawValue.lowercased() == name.lowercased() })
    }


    func cancelBooking(_ booking: Bookings) {
        booking.isExpired = true
        viewContext.saveData()
    }
}
