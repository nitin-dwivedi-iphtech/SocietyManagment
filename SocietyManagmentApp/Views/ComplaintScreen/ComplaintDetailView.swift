//
//  ComplaintDetailView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI
import CoreData

struct ComplaintDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var complaint: Complaint

    @StateObject private var viewModel = ComplaintViewModel()
    @State private var refreshTrigger: Bool = false

    private var isResolved: Bool {
        complaint.resolved
    }

    private var statusText: String {
        complaint.status?.capitalized ?? "Pending"
    }

    var body: some View {
        let _ = refreshTrigger

        VStack(spacing: 0) {

            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }

                Spacer()

                Text("Complaint Details")
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(statusText)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(viewModel.statusColor(for: complaint.status))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(viewModel.statusColor(for: complaint.status).opacity(0.12))
                                .clipShape(Capsule())

                            Spacer()

                            Text("ID: \(complaint.id?.uuidString.prefix(8).uppercased() ?? "N/A")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .monospaced()
                        }

                        Divider()
                            .padding(.vertical, 4)

                        Text("Description")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)

                        Text(complaint.desc ?? "No description provided.")
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(16)


                    if let uiImage = viewModel.complaintImage(for: complaint) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    HStack(spacing: 12) {
                        Image(systemName: isResolved ? "checkmark.circle.fill" : "clock.fill")
                            .font(.title3)
                            .foregroundColor(isResolved ? .green : .orange)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(isResolved ? "Complaint Resolved" : "Active Complaint")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(isResolved ? "This issue has been successfully resolved." : "Our team is looking into this issue.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }

            Spacer()

            if !isResolved {
                Button(action: {
                    viewModel.resolveComplaint(complaint)
                    refreshTrigger.toggle()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Resolved")
                            .fontWeight(.bold)
                    }
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green)
                    .cornerRadius(14)
                    .shadow(color: Color.green.opacity(0.2), radius: 6, x: 0, y: 3)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
