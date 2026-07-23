import SwiftUI

struct MaintenanceCheckOutView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var maintenance: Maintenance

    var onPayTap: () -> Void

    @StateObject private var viewModel = MaintenanceViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                MaintenanceCheckOutCardView(maintenance: maintenance, flatNo: "N/A")
                    .padding(.top, 16)

                MaintenanceCustomField(
                    text: $viewModel.paymentMethod,
                    title: "Payment Method",
                    placeholder: "Payment method eg. (Credit Card, UPI)"
                )
                .padding(.horizontal)

                MaintenanceCustomField(
                    text: $viewModel.upiId,
                    title: "UPI ID",
                    placeholder: "UPI ID"
                )
                .padding(.horizontal)

                Button(action: {
                    viewModel.processPayment(maintenance: maintenance)
                    onPayTap()
                    dismiss()
                }) {
                    Text("Pay Now ₹\(maintenance.amount.formatted(.number.precision(.fractionLength(2))))")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.green, in: RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Pay Maintenance")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.title3)
                }
            }
        }
    }
}

struct MaintenanceCustomField: View {
    @Binding var text: String
    var title: String
    var placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .font(.body)
        }
    }
}

struct MaintenanceCheckOutCardView: View {
    @ObservedObject var maintenance: Maintenance
    var flatNo: String

    var body: some View {
        VStack {
            HStack {
                Text("Month")
                    .foregroundStyle(.gray)
                Spacer()
                Text(maintenance.billMonth?.toMonthYearString() ?? "N/A")
                    .bold()
            }
            Divider()

            HStack {
                Text("Flat")
                    .foregroundStyle(.gray)
                Spacer()
                Text(flatNo)
                    .bold()
            }
            Divider()

            HStack {
                Text("Amount")
                    .foregroundStyle(.gray)
                Spacer()
                Text("₹\(maintenance.amount.formatted(.number.precision(.fractionLength(2))))")
                    .bold()
            }
        }
        .padding()
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}
