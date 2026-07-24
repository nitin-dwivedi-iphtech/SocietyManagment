//
//  NoticesViewModel.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 24/07/26.
//

import SwiftUI
import CoreData

@Observable
class NoticesViewModel{
    var notices: [Notices] = []
    var events: [Events] = []
    var selectedNoticeEnum: NoticesEnum = .all
    var showAddNotice: Bool = false
    var title: String = ""
    var description: String = ""
    var category: NoticesEnum = .general
    var isImportant: Bool = false
    var startDate: Date = Date()
    var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    var showValidation: Bool = false
    var validationMessage: String = ""
    var contentType: ContentType = .notice

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
            if item is Notices {
                fetchNotices()
            } else if item is Events {
                fetchEvents()
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
            fetchEvents()
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
            fetchNotices()
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
