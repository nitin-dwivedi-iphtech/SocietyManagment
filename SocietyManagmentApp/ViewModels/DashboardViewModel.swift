import SwiftUI
import CoreData
import Combine

class DashboardViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var showAmenitiesSheet: Bool = false
    @Published var selectedAmenityType: AmenitiesEnum?
    @Published var showNoticesSheet: Bool = false

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchProfile()
    }

    func fetchProfile() {
        let request: NSFetchRequest<Profile> = NSFetchRequest(entityName: "Profile")
        profile = try? viewContext.fetch(request).first
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

    func unpaidMaintenanceTotal(maintenances: [Maintenance]) -> Int {
        maintenances.filter { !$0.isPaid }.reduce(0) { $0 + Int($1.amount) }
    }

    func insideVisitorsCount(visitors: [Visitor]) -> Int {
        visitors.filter { $0.inside }.count
    }

    func openNoticesCount(notices: [Notices]) -> Int {
        notices.filter { !$0.isImportant }.count
    }

    func unpaidMaintenances(maintenances: [Maintenance]) -> [Maintenance] {
        maintenances.filter { !$0.isPaid }
    }
}
