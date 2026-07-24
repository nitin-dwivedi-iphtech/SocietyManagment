//
//  VisitorDetailScreen.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 23/07/26.
//

import SwiftUI

struct VisitorDetailScreen: View {
    @ObservedObject var visitor:Visitor
    @Environment(\.dismiss) private var dismiss
    
    var status:String{
        if visitor.inside && !visitor.exited {
            return "inside"
        }
        else if visitor.exited && !visitor.inside {
            return "exited"
        }
        else {
            return "outside"
        }
    }
    
    var statusColor:Color{
        if visitor.inside && !visitor.exited {
            return .green
        }
        else if visitor.exited && !visitor.inside {
            return .gray
        }
        else {
            return .red
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.accentColor)
                    
                    Text(visitor.name ?? "N/A")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(status)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.15))
                        .foregroundColor(statusColor)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(16)
                
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Visitor Details")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 12) {
                        DetailRow(icon: "phone.fill", label: "Phone Number", value: visitor.phone ?? "N/A")
                        Divider()
                        DetailRow(icon: "building.2.fill", label: "Flat / Unit No.", value: visitor.flat_no ?? "N/A")
                        Divider()
                        DetailRow(icon: "bag.fill", label: "Purpose of Visit", value: visitor.purpose ?? "N/A")
                        Divider()
                        DetailRow(icon: "clock.fill", label: "Entry Time", value: visitor.arrival_time?.toMonthYearString() ?? "N/A")
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("Visitor Info")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
        }
    }
    
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
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
    }
}

//#Preview {
//    NavigationView {
//        VisitorDetailScreen()
//    }
//}
