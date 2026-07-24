//
//  MaintenanceRowView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI

struct MaintenanceRowView: View {

    @Binding var selectedTabView: Int
    @Environment(MaintenanceViewModel.self) var maintenanceVM: MaintenanceViewModel

    var unpaidMaintenances: [Maintenance] {
        maintenanceVM.maintenances.filter { !$0.isPaid }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Maintenance")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        selectedTabView = 3
                    }
            }

            if unpaidMaintenances.isEmpty {
                Text("No Pay due!")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(unpaidMaintenances) { maintenance in
                    MaintenanceSubRowView(selectedTabView: $selectedTabView, maintenance: maintenance)
                }
            }
        }
        .padding()
    }
}

struct MaintenanceSubRowView: View {
    @Binding var selectedTabView: Int
    @ObservedObject var maintenance: Maintenance

    var body: some View {
        HStack {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 15))
                .padding(.trailing, 5)
            VStack(alignment: .leading) {
                Text("\(maintenance.billMonth?.toMonthYearString() ?? "N/A") maintenance")
                    .font(.system(size: 13))

                Text("\(maintenance.amount.formatted(.number.precision(.fractionLength(2)))) Due by \(maintenance.dueDate?.toMonthYearString() ?? "N/A")")
                    .font(.system(size: 10))
            }
            Spacer()
            Button(action: {
                selectedTabView = 3
            }) {
                Text("Pay")
                    .font(.system(size: 12))
                    .padding(.all, 8)
                    .foregroundColor(.white)
                    .background(Color.orange, in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .background(Color.orange.opacity(0.12))
        .clipShape(Capsule())
    }
}
