//
//  DashboardViewModel.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 24/07/26.
//

import SwiftUI
import CoreData

@Observable
class DashboardViewModel{
    var profile: Profile?
    var showAmenitiesSheet: Bool = false
    var selectedAmenityType: AmenitiesEnum?
    var showNoticesSheet: Bool = false

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
