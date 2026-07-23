import SwiftUI
import CoreData
import Combine

class DashboardViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var maintenances: [Maintenance] = []
    @Published var visitors: [Visitor] = []
    @Published var notices: [Notices] = []
    @Published var events: [Events] = []
    @Published var amenities: [Amenities] = []
    @Published var showAmenitiesSheet: Bool = false
    @Published var selectedAmenityType: AmenitiesEnum?
    @Published var showNoticesSheet: Bool = false

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchAll()
    }
    
    func fetchAll() {
        fetchProfile()
        fetchMaintenances()
        fetchVisitors()
        fetchNotices()
        fetchEvents()
        fetchAmenities()
    }

    func fetchProfile() {
        let request: NSFetchRequest<Profile> = NSFetchRequest(entityName: "Profile")
        profile = try? viewContext.fetch(request).first
    }

    func fetchMaintenances() {
        let request: NSFetchRequest<Maintenance> = NSFetchRequest(entityName: "Maintenance")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Maintenance.billMonth, ascending: false)]
        maintenances = (try? viewContext.fetch(request)) ?? []
    }

    func fetchVisitors() {
        let request: NSFetchRequest<Visitor> = NSFetchRequest(entityName: "Visitor")
        visitors = (try? viewContext.fetch(request)) ?? []
    }

    func fetchNotices() {
        let request: NSFetchRequest<Notices> = NSFetchRequest(entityName: "Notices")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Notices.postedDate, ascending: false)]
        notices = (try? viewContext.fetch(request)) ?? []
    }

    func fetchEvents() {
        let request: NSFetchRequest<Events> = NSFetchRequest(entityName: "Events")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Events.startDate, ascending: true)]
        events = (try? viewContext.fetch(request)) ?? []
    }

    func fetchAmenities() {
        let request: NSFetchRequest<Amenities> = NSFetchRequest(entityName: "Amenities")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Amenities.name, ascending: true)]
        amenities = (try? viewContext.fetch(request)) ?? []
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        case 17..<21: return "Good Evening,"
        default: return "Good Night,"
        }
    }

    var unpaidMaintenanceTotal: Int {
        maintenances.filter { !$0.isPaid }.reduce(0) { $0 + Int($1.amount) }
    }

    var insideVisitorsCount: Int {
        visitors.filter { $0.inside }.count
    }

    var openNoticesCount: Int {
        notices.filter { !$0.isImportant }.count
    }

    var unpaidMaintenances: [Maintenance] {
        maintenances.filter { !$0.isPaid }
    }
}
