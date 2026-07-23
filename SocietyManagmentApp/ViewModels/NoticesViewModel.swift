import SwiftUI
import CoreData
import Combine

class NoticesViewModel: ObservableObject {
    @Published var notices: [Notices] = []
    @Published var events: [Events] = []
    @Published var selectedNoticeEnum: NoticesEnum = .all
    @Published var showAddNotice: Bool = false
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var category: NoticesEnum = .general
    @Published var isImportant: Bool = false
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @Published var showValidation: Bool = false
    @Published var validationMessage: String = ""
    @Published var contentType: ContentType = .notice

    enum ContentType: String, CaseIterable, Identifiable {
        case notice = "Notice"
        case event = "Event"
        var id: String { rawValue }
    }

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchNotices()
        fetchEvents()
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


    var isDateInvalid: Bool {
        contentType == .event && endDate <= startDate
    }

    var filteredNotices: [Notices] {
        if selectedNoticeEnum == .all {
            return notices
        } else if selectedNoticeEnum == .events {
            return []
        } else {
            return notices.filter { $0.category == selectedNoticeEnum.rawValue }
        }
    }

    var filteredEvents: [Events] {
        if selectedNoticeEnum == .all || selectedNoticeEnum == .events {
            return events
        } else {
            return []
        }
    }

    var isListEmpty: Bool {
        filteredNotices.isEmpty && filteredEvents.isEmpty
    }


    func deleteItem<T: NSManagedObject>(_ item: T) {
        withAnimation {
            viewContext.delete(item)
            viewContext.saveData()
            if let notice = item as? Notices {
                notices.removeAll { $0 == notice }
            } else if let event = item as? Events {
                events.removeAll { $0 == event }
            }
        }
    }

    func saveNotice(profile: Profile) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            validationMessage = "Please enter a title."
            showValidation = true
            return
        }

        if contentType == .event && endDate <= startDate {
            validationMessage = "End date must be after the start date."
            showValidation = true
            return
        }

        if contentType == .event {
            let event = Events(context: viewContext)
            event.id = UUID()
            event.title = trimmedTitle
            event.details = description
            event.startDate = startDate
            event.endDate = endDate
            event.category = NoticesEnum.events.rawValue
            event.profileId = profile.id

            NotificationManager.shared.sendNotification(
                title: "New Event Added",
                body: "\(trimmedTitle) has been scheduled.",
                timeInterval: 1
            )

            NotificationManager.shared.scheduleNotification(
                title: "Event Starting Now!",
                body: "\(trimmedTitle) is starting at \(startDate.formatted(date: .omitted, time: .shortened)).",
                triggerDate: startDate
            )

            viewContext.saveData()
            events.insert(event, at: 0)
        } else {
            let notice = Notices(context: viewContext)
            notice.id = UUID()
            notice.title = trimmedTitle
            notice.body = description
            notice.authorName = profile.name
            notice.category = category.rawValue
            notice.isImportant = isImportant
            notice.postedDate = Date()
            notice.profileId = profile.id

            let noticeTitle = isImportant ? "Important Notice Posted" : "New Notice Published"
            NotificationManager.shared.sendNotification(
                title: noticeTitle,
                body: "\(trimmedTitle) — check the app for details.",
                timeInterval: 1
            )

            viewContext.saveData()
            notices.insert(notice, at: 0)
        }

        resetForm()
    }

    func resetForm() {
        title = ""
        description = ""
        category = .general
        isImportant = false
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        contentType = .notice
    }
}
