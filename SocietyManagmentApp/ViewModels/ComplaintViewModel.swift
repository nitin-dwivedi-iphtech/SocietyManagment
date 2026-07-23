import SwiftUI
import CoreData
import Combine

class ComplaintViewModel: ObservableObject {
    @Published var complaints: [Complaint] = []
    @Published var searchText: String = ""
    @Published var selectedPill: ComplaintEnum = .all
    @Published var showAddComplaint: Bool = false
    @Published var showComplaintDetail: Bool = false
    @Published var selectedComplaint: Complaint?

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchComplaints()
    }


    func fetchComplaints() {
        let request: NSFetchRequest<Complaint> = NSFetchRequest(entityName: "Complaint")
        request.sortDescriptors = []
        complaints = (try? viewContext.fetch(request)) ?? []
    }


    var filteredComplaints: [Complaint] {
        switch selectedPill {
        case .all:
            return complaints
        case .open:
            return complaints.filter { $0.status?.lowercased() == "pending" && !$0.resolved }
        case .inProgress:
            return complaints.filter { $0.status?.lowercased() == "in progress" && !$0.resolved }
        case .done:
            return complaints.filter { $0.resolved }
        }
    }

    var searchFilteredComplaints: [Complaint] {
        guard !searchText.isEmpty else { return filteredComplaints }
        let lowercasedQuery = searchText.lowercased()
        return filteredComplaints.filter { $0.desc?.lowercased().contains(lowercasedQuery) ?? false }
    }


    var openComplaintsCount: Int {
        complaints.filter { !$0.resolved }.count
    }

    func dynamicCount(for filter: ComplaintEnum) -> Int {
        switch filter {
        case .all:
            return complaints.count
        case .open:
            return complaints.filter { $0.status?.lowercased() == "pending" && !$0.resolved }.count
        case .inProgress:
            return complaints.filter { $0.status?.lowercased() == "in progress" && !$0.resolved }.count
        case .done:
            return complaints.filter { $0.resolved }.count
        }
    }


    func resolveComplaint(_ complaint: Complaint) {
        withAnimation(.spring()) {
            complaint.resolved = true
            complaint.status = "Resolved"
            viewContext.saveData()
        }
    }

    func addComplaint(profileId: UUID, description: String, category: ComplaintCategoryEnum, status: String, imageUrl: String?) {
        let newComplaint = Complaint(context: viewContext)
        newComplaint.id = UUID()
        newComplaint.personId = profileId
        newComplaint.category = category.id
        newComplaint.desc = "[\(category.id)] \(description)"
        newComplaint.status = status
        newComplaint.resolved = (status == "Resolved")
        if let url = imageUrl {
            newComplaint.image = url
        }
        viewContext.saveData()
        complaints.insert(newComplaint, at: 0)
    }

    func deleteComplaint(_ complaint: Complaint) {
        withAnimation {
            viewContext.delete(complaint)
            viewContext.saveData()
            complaints.removeAll { $0 == complaint }
        }
    }


    func complaintImage(for complaint: Complaint) -> UIImage? {
        guard let fileName = complaint.image,
              let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let currentImageURL = documentsURL.appendingPathComponent(fileName)
        guard let imageData = try? Data(contentsOf: currentImageURL) else {
            return nil
        }
        return UIImage(data: imageData)
    }

    func statusColor(for status: String?) -> Color {
        switch status?.lowercased() {
        case "pending", "open":
            return .orange
        case "in progress", "inprogress":
            return .blue
        case "resolved", "done":
            return .green
        default:
            return .secondary
        }
    }
}
