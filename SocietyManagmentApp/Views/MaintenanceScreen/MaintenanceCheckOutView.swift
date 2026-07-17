import SwiftUI

struct MaintenanceCheckOutView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State var paymentMethod: String = ""
    @State var upiId: String = ""
    
    @ObservedObject var maintenance: Maintenance
    @ObservedObject var profile: Profile
    
    var onPayTap: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                MaintenanceCheckOutCardView(maintenance: maintenance, profile: profile)
                    .padding(.top, 16)
                
                MaintenanceCustomField(
                    text: $paymentMethod,
                    title: "Payment Method",
                    placeholder: "Payment method eg. (Credit Card, UPI)"
                )
                .padding(.horizontal)
                
                MaintenanceCustomField(
                    text: $upiId,
                    title: "UPI ID",
                    placeholder: "UPI ID"
                )
                .padding(.horizontal)
                
                Button(action: {
                    maintenance.isPaid = true
                    maintenance.status = "Paid"
                    maintenance.transactionId = UUID()
                    
                    maintenance.receiptNo = "REC-\(Int.random(in: 100000...999999))"
                    
                    if let dueDate = maintenance.dueDate {
                        let calendar = Calendar.current
                        let dueMonth = calendar.component(.month, from: dueDate)
                        let dueDay = calendar.component(.day, from: dueDate)
                        
                        var payComponents = DateComponents()
                        payComponents.year = 2026
                        payComponents.month = dueMonth
                        payComponents.day = max(1, dueDay - 2)
                        
                        maintenance.paymentDate = calendar.date(from: payComponents)
                    } else {
                        maintenance.paymentDate = Date()
                    }
                    viewContext.saveData()
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
    @ObservedObject var profile: Profile
    
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
                Text(profile.flat_no ?? "N/A")
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
