//
//  AddComplaintView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI
internal import CoreData

struct AddComplaintView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var descriptionText: String = ""
    @State private var selectedStatus: String = "Pending"
    @State private var selectedCategory: ComplaintCategoryEnum = .general
    @State private var attachedImageURL: String = ""
    
    @ObservedObject var profile: Profile
    
    let statusOptions = ["Pending", "In Progress", "Resolved"]
    
    var isFormValid: Bool {
        !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ComplaintCategoryEnum.allCases) { category in
                            HStack {
                                Image(systemName: category.iconName)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Department / Category")
                }
                
                Section {
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 120)
                        .overlay(alignment: .topLeading) {
                            if descriptionText.isEmpty {
                                Text("Describe the issue clearly...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                                    .allowsHitTesting(false)
                            }
                        }
                } header: {
                    Text("Complaint Details")
                }
                
                Section {
                    Picker("Initial Status", selection: $selectedStatus) {
                        ForEach(statusOptions, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Status Configuration")
                }
                
                Section {
                    HStack {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.blue)
                        TextField("Image URL / Attachment Path (Optional)", text: $attachedImageURL)
                            .font(.system(.subheadline, design: .monospaced))
                    }
                } header: {
                    Text("Attachment Link")
                }
            }
            .navigationTitle("New Complaint")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        saveComplaint()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func saveComplaint() {
        let newComplaint = Complaint(context: viewContext)
        newComplaint.id = UUID()
        newComplaint.personId = profile.id
        
        newComplaint.category = selectedCategory.id
        
        newComplaint.desc = "[\(selectedCategory.id)] \(descriptionText)"
        
        newComplaint.status = selectedStatus
        newComplaint.resolved = (selectedStatus == "Resolved")
        
        if !attachedImageURL.isEmpty {
            newComplaint.image = URL(string: attachedImageURL)
        }
        viewContext.saveData()
    }
}
