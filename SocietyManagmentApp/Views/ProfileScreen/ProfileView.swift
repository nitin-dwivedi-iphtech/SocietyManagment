import SwiftUI
import CoreData

struct ProfileView: View {

    @Environment(ProfileViewModel.self) var viewModel: ProfileViewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HStack {
                    ProfileHeaderView(bookMarkTap: {
                        viewModel.showBookingsSheet = true
                    })
                    Spacer()
                }
                .padding(.top, 5)

                if let profile = viewModel.profile {
                    ProfileCardView(profile: profile)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Resident Details")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)

                        VStack(spacing: 0) {
                            ProfileDetailRow(
                                icon: "house.fill",
                                label: "Flat No.",
                                value: viewModel.flatNo
                            )
                            Divider().padding(.leading, 44)

                            ProfileDetailRow(
                                icon: "person.2.fill",
                                label: "Family Members",
                                value: "\(viewModel.familyMembers)"
                            )
                            Divider().padding(.leading, 44)

                            ProfileDetailRow(
                                icon: "calendar",
                                label: "Date of Birth",
                                value: viewModel.dobFormatted
                            )
                        }
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact Information")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)

                        VStack(spacing: 0) {
                            ProfilePhoneRow(
                                icon: "phone.fill",
                                label: "Phone",
                                phoneNumber: viewModel.phone,
                                onCall: { viewModel.callPhone(viewModel.phone) }
                            )

                            Divider().padding(.leading, 44)

                            ProfilePhoneRow(
                                icon: "exclamationmark.bubble.fill",
                                label: "Emergency Contact",
                                phoneNumber: viewModel.emergencyNo,
                                onCall: { viewModel.callPhone(viewModel.emergencyNo) }
                            )
                        }
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                    }
                }

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.showBookingsSheet) {
            BookingView()
        }
    }
}

struct ProfileDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 30, height: 30)
                .background(Color.green.opacity(0.1), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
            Spacer()
        }
        .padding()
    }
}

struct ProfilePhoneRow: View {
    let icon: String
    let label: String
    let phoneNumber: String?
    var onCall: (() -> Void)?

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 30, height: 30)
                .background(Color.green.opacity(0.1), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(phoneNumber ?? "Not Added")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(phoneNumber != nil ? .primary : .secondary)
            }

            Spacer()

            Button(action: {
                onCall?()
            }) {
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
            }
            .buttonStyle(.borderless)

        }
        .padding()
    }
}
