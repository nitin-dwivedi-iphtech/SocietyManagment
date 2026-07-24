import SwiftUI
import CoreData
import PhotosUI

struct AddComplaintView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var descriptionText: String = ""
    @State private var selectedStatus: String = "Pending"
    @State private var selectedCategory: ComplaintCategoryEnum = .general
    @State private var selectedPhotoImage: PhotosPickerItem? = nil
    @State private var imageUrl: String? = nil

    var profileId: UUID

    @Environment(ComplaintViewModel.self) var viewModel: ComplaintViewModel

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
                    CustomPhotoPicker(selectedPhotoImage: $selectedPhotoImage, imageUrl: $imageUrl)
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
                        viewModel.addComplaint(
                            profileId: profileId,
                            description: descriptionText,
                            category: selectedCategory,
                            status: selectedStatus,
                            imageUrl: imageUrl
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(!isFormValid)
                }
            }
        }
    }
}


struct CustomPhotoPicker: View {
    @Binding var selectedPhotoImage: PhotosPickerItem?
    @Binding var imageUrl: String?

    @State private var previewImage: UIImage? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            if let image = previewImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button(action: removeSelectedPhoto) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.6).clipShape(Circle()))
                    }
                    .padding(8)
                }

                PhotosPicker(selection: $selectedPhotoImage, matching: .images) {
                    Label("Change Photo", systemImage: "photo.badge.plus")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            } else {
                PhotosPicker(selection: $selectedPhotoImage, matching: .images) {
                    HStack(spacing: 10) {
                        if isLoading {
                            ProgressView()
                                .padding(.trailing, 4)
                        } else {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(isLoading ? "Saving Photo..." : "Attach Photo")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("JPEG or PNG from your library")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 6)
                }
                .disabled(isLoading)
            }
        }
        .onChange(of: selectedPhotoImage) { _, newItem in
            transformImage(newItem: newItem)
        }
    }

    private func transformImage(newItem: PhotosPickerItem?) {
        guard let newItem = newItem else { return }

        isLoading = true

        Task {
            if let data = try? await newItem.loadTransferable(type: Data.self) {
                if let loadedUIImage = UIImage(data: data) {
                    await MainActor.run {
                        self.previewImage = loadedUIImage
                    }
                }

                let url = saveImage(data: data)

                Task { @MainActor in
                    self.imageUrl = url
                    self.isLoading = false
                }
            } else {
                Task { @MainActor in
                    self.isLoading = false
                }
            }
        }
    }

    private func removeSelectedPhoto() {
        withAnimation {
            if let fileName = imageUrl,
               let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileUrl = documentsDirectory.appendingPathComponent(fileName)
                try? FileManager.default.removeItem(at: fileUrl)
            }

            selectedPhotoImage = nil
            previewImage = nil
            imageUrl = nil
        }
    }

    private func saveImage(data: Data) -> String? {
        let fileName = "\(UUID().uuidString).jpg"

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let fileUrl = documentsDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileUrl)
            return fileName
        } catch {
            print("Error saving image:", error)
            return nil
        }
    }
}
