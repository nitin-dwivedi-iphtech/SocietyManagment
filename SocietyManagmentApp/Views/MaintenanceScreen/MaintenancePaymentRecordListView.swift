//
//  MaintenanceListView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI
import CoreData

struct MaintenancePaymentRecordListView: View {

    @Environment(MaintenanceViewModel.self) var viewModel: MaintenanceViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.maintenances.isEmpty {
                ContentUnavailableView {
                    Label("No Records Found", systemImage: "creditcard.trianglebadge.exclamationmark")
                } description: {
                    Text("Your monthly society maintenance history will appear here.")
                }
            } else {
                ForEach(viewModel.maintenances) { record in
                    MaintenanceHistoryRow(record: record, profile: viewModel.profile)
                    Divider().padding(.all, 2)
                }
            }
        }
    }
}

struct MaintenanceHistoryRow: View {
    @ObservedObject var record: Maintenance
    var profile: Profile?

    @State private var showDownloadError = false

    private func statusColor(for status: String?) -> Color {
        switch status {
        case "Paid": return .green
        case "Pending": return .orange
        case "Overdue": return .red
        default: return .secondary
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.billMonth?.toMonthYearString() ?? "Unknown")
                    .font(.headline)

                Text(record.status ?? "Unpaid")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(statusColor(for: record.status))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("₹\(String(format: "%.2f", record.amount))")
                    .font(.headline)
                    .foregroundColor(.primary)

                if record.status == "Paid" {
                    if let profile = profile,
                       let pdfURL = GeneratePdf(maintenance: record, profile: profile) {
                        ShareLink(item: pdfURL) {
                            Label("Receipt", systemImage: "arrow.down.doc")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        .controlSize(.small)
                    } else {
                        Button(action: {
                            showDownloadError = true
                        }) {
                            Label("Receipt", systemImage: "exclamationmark.circle")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .controlSize(.small)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .alert("Download Failed", isPresented: $showDownloadError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Unable to generate the receipt for \(record.billMonth?.toMonthYearString() ?? "this month") at this moment. Please try again later.")
        }
    }
}
