//
//  NoticesAddView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct NoticesAddView: View {
    enum ContentType: String, CaseIterable, Identifiable {
        case notice = "Notice"
        case event = "Event"
        var id: String { rawValue }
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var profile: Profile
    
    @State private var type: ContentType = .notice
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: NoticesEnum = .general
    @State private var isImportant: Bool = false
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    
    @State private var showValidation: Bool = false
    @State private var validationMessage: String = ""
    
    private var isDateInvalid: Bool {
        type == .event && endDate <= startDate
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Type")) {
                    Picker("Type", selection: $type) {
                        ForEach(ContentType.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(4...8)
                }
                
                if type == .event {
                    Section(
                        header: Text("Event Schedule"),
                        footer: Group {
                            if isDateInvalid {
                                Text("End date must be after start date.")
                                    .foregroundStyle(.red)
                            }
                        }
                    ) {
                        DatePicker("Start Date", selection: $startDate, in: Date()...)
                        DatePicker("End Date", selection: $endDate, in: startDate...)
                    }
                }
                
                Section(header: Text("Classification")) {
                    if type == .event {
                        HStack {
                            Text("Category")
                            Spacer()
                            Text(NoticesEnum.events.rawValue)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Picker("Category", selection: Binding(
                            get: { category == .events ? .general : category },
                            set: { category = $0 }
                        )) {
                            ForEach(NoticesEnum.allCases.filter { $0 != .all && $0 != .events }, id: \.self) { item in
                                Text(item.rawValue).tag(item)
                            }
                        }
                        
                        Toggle("Mark as Important", isOn: $isImportant)
                    }
                }
            }
            .onChange(of: type) { _, newValue in
                if newValue == .event {
                    category = .events
                } else if category == .events {
                    category = .general
                }
            }
            .navigationTitle("New \(type.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        save()
                    } label: {
                        Text("Save").bold()
                        
                    }
                }
            }
            .alert("Validation Error", isPresented: $showValidation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
        .tint(.accentColor)
    }
    
    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            validationMessage = "Please enter a title."
            showValidation = true
            return
        }
        
        if type == .event && endDate <= startDate {
            validationMessage = "End date must be after the start date."
            showValidation = true
            return
        }
        
        
        if type == .event {
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
        }
        
        viewContext.saveData()
        
        
        
        dismiss()
    }
}
