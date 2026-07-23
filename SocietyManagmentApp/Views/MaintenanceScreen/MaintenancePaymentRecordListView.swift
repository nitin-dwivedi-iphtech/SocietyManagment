//
//  MaintenanceListView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI
import CoreData

struct MaintenancePaymentRecordListView: View {

    @StateObject private var viewModel = MaintenanceViewModel()

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
                    MaintenanceHistoryRow(record: record)
                    Divider().padding(.all, 2)
                }
            }
        }
    }
}

struct MaintenanceHistoryRow: View {
    @ObservedObject var record: Maintenance

    @StateObject private var viewModel = MaintenanceViewModel()
    @State private var showDownloadError = false

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.billMonth?.toMonthYearString() ?? "Unknown")
                    .font(.headline)

                Text(record.status ?? "Unpaid")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(viewModel.statusColor(for: record.status))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("₹\(String(format: "%.2f", record.amount))")
                    .font(.headline)
                    .foregroundColor(.primary)

                if record.status == "Paid" {
                    if let profile = viewModel.profile,
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
