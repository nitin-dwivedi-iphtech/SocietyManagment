import SwiftUI
import CoreData
import Combine

class MaintenanceViewModel: ObservableObject {
    @Published var maintenances: [Maintenance] = []
    @Published var isPaymentCompleted: Bool = false
    @Published var pendingMaintenances: [Maintenance] = []
    @Published var latestPaidMaintenance: Maintenance?
    @Published var selectedMaintenanceForPayment: Maintenance?
    @Published var paymentMethod: String = ""
    @Published var upiId: String = ""
    @Published var profile: Profile?

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchProfile()
        fetchMaintenances()
    }

    func fetchProfile() {
        let request: NSFetchRequest<Profile> = NSFetchRequest(entityName: "Profile")
        request.fetchLimit = 1
        profile = try? viewContext.fetch(request).first
    }

    func fetchMaintenances() {
        let request: NSFetchRequest<Maintenance> = NSFetchRequest(entityName: "Maintenance")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Maintenance.billMonth, ascending: false)]
        maintenances = (try? viewContext.fetch(request)) ?? []
        updateMaintenanceState()
    }

    func updateMaintenanceState() {
        pendingMaintenances = maintenances.filter { !$0.isPaid }
        if pendingMaintenances.isEmpty {
            isPaymentCompleted = true
            latestPaidMaintenance = maintenances.first
        } else {
            isPaymentCompleted = false
        }
    }

    func processPayment(maintenance: Maintenance) {
        maintenance.isPaid = true
        maintenance.status = "Paid"
        maintenance.transactionId = UUID()
        maintenance.receiptNo = "REC-\(Int.random(in: 100000...999999))"

        if let dueDate = maintenance.dueDate {
            let calendar = Calendar.current
            let dueMonth = calendar.component(.month, from: dueDate)
            let dueDay = calendar.component(.day, from: dueDate)

            var payComponents = DateComponents()
            payComponents.year = calendar.component(.year, from: Date())
            payComponents.month = dueMonth
            payComponents.day = max(1, dueDay - 2)

            maintenance.paymentDate = calendar.date(from: payComponents)
        } else {
            maintenance.paymentDate = Date()
        }
        viewContext.saveData()
        isPaymentCompleted = true
        updateMaintenanceState()
    }

    var headerSubtitle: String {
        isPaymentCompleted ? "All dues cleared!" : "Pending dues found"
    }

    func statusColor(for status: String?) -> Color {
        switch status {
        case "Paid": return .green
        case "Pending": return .orange
        case "Overdue": return .red
        default: return .secondary
        }
    }
}
