//
//  NoticesAddView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import SwiftUI
import CoreData

struct NoticesAddView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var profile: Profile

    @EnvironmentObject var viewModel: NoticesViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Type")) {
                    Picker("Type", selection: $viewModel.contentType) {
                        ForEach(NoticesViewModel.ContentType.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Details")) {
                    TextField("Title", text: $viewModel.title)
                        .textInputAutocapitalization(.sentences)

                    TextField("Description", text: $viewModel.description, axis: .vertical)
                        .lineLimit(4...8)
                }

                if viewModel.contentType == .event {
                    Section(
                        header: Text("Event Schedule"),
                        footer: Group {
                            if viewModel.isDateInvalid {
                                Text("End date must be after start date.")
                                    .foregroundStyle(.red)
                            }
                        }
                    ) {
                        DatePicker("Start Date", selection: $viewModel.startDate, in: Date()...)
                        DatePicker("End Date", selection: $viewModel.endDate, in: viewModel.startDate...)
                    }
                }

                Section(header: Text("Classification")) {
                    if viewModel.contentType == .event {
                        HStack {
                            Text("Category")
                            Spacer()
                            Text(NoticesEnum.events.rawValue)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Picker("Category", selection: Binding(
                            get: { viewModel.category == .events ? .general : viewModel.category },
                            set: { viewModel.category = $0 }
                        )) {
                            ForEach(NoticesEnum.allCases.filter { $0 != .all && $0 != .events }, id: \.self) { item in
                                Text(item.rawValue).tag(item)
                            }
                        }

                        Toggle("Mark as Important", isOn: $viewModel.isImportant)
                    }
                }
            }
            .onChange(of: viewModel.contentType) { _, newValue in
                if newValue == .event {
                    viewModel.category = .events
                } else if viewModel.category == .events {
                    viewModel.category = .general
                }
            }
            .navigationTitle("New \(viewModel.contentType.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.saveNotice(profile: profile)
                        dismiss()
                    } label: {
                        Text("Save").bold()

                    }
                }
            }
            .alert("Validation Error", isPresented: $viewModel.showValidation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.validationMessage)
            }
        }
        .tint(.accentColor)
    }
}
