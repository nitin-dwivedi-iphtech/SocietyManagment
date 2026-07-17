//
//  MaintenanceView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI
internal import CoreData

struct MaintenanceView: View {
    
    var maintenances: FetchedResults<Maintenance>
    @ObservedObject var profile: Profile
    
    @State private var isPaymentCompleted = false
    @State private var pendingMaintenances: [Maintenance] = []
    @State private var latestPaidMaintenance: Maintenance? = nil
    @State private var selectedMaintenanceForPayment: Maintenance? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                MaintenanceHeaderView(isPaid: isPaymentCompleted)
                Spacer()
            }
            .padding(.bottom, 5)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    if !pendingMaintenances.isEmpty {
                        TabView {
                            ForEach(pendingMaintenances, id: \.self) { pendingItem in
                                MaintenanceCardView(
                                    maintenance: pendingItem,
                                    profile: profile,
                                    isPaid: .constant(false),
                                    onPayTap: {
                                        self.selectedMaintenanceForPayment = pendingItem
                                    }
                                )
                                .padding(.horizontal, 4)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(height: 290)
                        
                    } else if let paidItem = latestPaidMaintenance {
                        MaintenanceCardView(
                            maintenance: paidItem,
                            profile: profile,
                            isPaid: .constant(true),
                            onPayTap: {}
                        )
                    } else {
                        ContentUnavailableView("No Records", systemImage: "creditcard", description: Text("No maintenance schedule found."))
                            .frame(height: 200)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            MaintenanceSubCardView(
                                image: "calendar",
                                title: "Monthly",
                                subtitle: "₹3,500 Due"
                            )
                            
                            MaintenanceSubCardView(
                                image: "clock.arrow.circlepath",
                                title: "History",
                                subtitle: "Past Payments"
                            )
                            
                            MaintenanceSubCardView(
                                image: "arrow.down.doc",
                                title: "Receipts",
                                subtitle: "Get Dummy PDF"
                            )
                        }
                    }
                    
                    MaintenancePaymentRecordListView(maintenanceRecords: maintenances, profile: profile)
                }
            }
        }
        .padding()
        .navigationBarHidden(true)
        .onAppear {
            updateMaintenanceState()
        }
        .onChange(of: maintenances.map { $0.isPaid }) {
            updateMaintenanceState()
        }
        .sheet(item: $selectedMaintenanceForPayment) { selectedItem in
            NavigationStack {
                MaintenanceCheckOutView(
                    maintenance: selectedItem,
                    profile: profile, onPayTap: {
                        self.isPaymentCompleted = true
                        updateMaintenanceState()
                    }
                )
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private func updateMaintenanceState() {
        pendingMaintenances = maintenances.filter { !$0.isPaid }
        if pendingMaintenances.isEmpty {
            isPaymentCompleted = true
            latestPaidMaintenance = maintenances.first
        } else {
            isPaymentCompleted = false
        }
    }
}

struct MaintenanceHeaderView: View {
    var isPaid: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Maintenance")
                .font(.title)
                .bold()
            
            Text(isPaid ? "All dues cleared!" : "Pending dues found")
                .font(.system(size: 15))
                .foregroundStyle(isPaid ? .green : .secondary)
        }
    }
}

struct MaintenanceCardView: View {
    let maintenance: Maintenance
    @ObservedObject var profile: Profile
    @Binding var isPaid: Bool
    
    var onPayTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                    .padding(.all, 5)
                    .background(.white)
                    .clipShape(Capsule())
                
                Text("Green Valley Residency")
                    .font(.headline)
                    .foregroundStyle(.green)
            }
            
            Text("Flat \(profile.flat_no ?? "N/A") • \(profile.name ?? "N/A")")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.7))
            
            Text("₹\(maintenance.amount.formatted(.number.precision(.fractionLength(2))))")
                .foregroundStyle(.white)
                .font(.system(size: 34, weight: .bold))
            
            Text("\(maintenance.billMonth?.toMonthYearString() ?? "Pending Month") • Due by \(maintenance.dueDate?.toMonthYearString() ?? "N/A")")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.bottom, 10)
            
            Button(action: {
                onPayTap()
            }) {
                Text(isPaid ? "Paid ✓" : "Pay Now")
                    .font(.headline)
                    .foregroundStyle(isPaid ? .white : .black)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(isPaid ? Color.gray.opacity(0.3) : Color.green, in: RoundedRectangle(cornerRadius: 10))
            }
            .disabled(isPaid)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [.grandGreen, .grandBlack],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            ),
            in: RoundedRectangle(cornerRadius: 15)
        )
    }
}

struct MaintenanceSubCardView: View {
    var image: String
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: image)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.green)
                .frame(width: 48, height: 48)
                .background(Color.green.opacity(0.1))
                .clipShape(Circle())
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 115, height: 125)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
