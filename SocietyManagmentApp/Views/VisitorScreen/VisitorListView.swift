//
//  VisitorListView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI


struct VisitorListView: View {
    @ObservedObject var visitor: Visitor
    private var statusColor: Color {
        if visitor.inside {
            return .green
        } else {
            let arrival = visitor.arrival_time ?? Date()
            if arrival >= Date() {
                return .red
            } else {
                return Color(.systemGray4)
            }
        }
    }
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)
                .shadow(
                    color: (visitor.inside && !visitor.exited ? Color.green : Color.clear).opacity(0.3),
                    radius: 4,
                    x: 0,
                    y: 0
                )
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(visitor.name ?? "Unknown Visitor")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(visitor.flat_no ?? "N/A")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.08))
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "info.circle")
                        .font(.caption2)
                    Text("Purpose: \(visitor.purpose ?? "N/A")")
                        .font(.system(.footnote, design: .rounded))
                }
                .foregroundColor(.secondary)
                
                if let vehicleNo = visitor.vehicle_no, !vehicleNo.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "car.fill")
                            .font(.caption2)
                        Text(vehicleNo)
                            .font(.system(.caption2, design: .rounded))
                    }
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(4)
                }
            }
            
            if let arrivalTime = visitor.arrival_time {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(arrivalTime, style: .time)
                        .font(.system(.footnote, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(arrivalTime, style: .date)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.all, 16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
}

//#Preview {
//    VisitorListView()
//}
