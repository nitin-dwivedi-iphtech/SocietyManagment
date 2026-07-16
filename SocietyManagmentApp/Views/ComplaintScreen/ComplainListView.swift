//
//  ComplainListView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI

struct ComplainListView: View {
    @ObservedObject var complaint: Complaint
    
    private var category: ComplaintCategoryEnum {
        let desc = complaint.desc?.lowercased() ?? ""
        
        if desc.contains("plumbing") || desc.contains("drop") {
            return .plumbing
        } else if desc.contains("electrical") || desc.contains("electricity") || desc.contains("bolt") || desc.contains("power") {
            return .electrical
        } else if desc.contains("security") || desc.contains("shield") || desc.contains("gate") {
            return .security
        } else if desc.contains("housekeeping") || desc.contains("trash") || desc.contains("garbage") {
            return .housekeeping
        } else if desc.contains("lift") || desc.contains("elevator") {
            return .lift
        } else {
            return .general
        }
    }
    
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: category.iconName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(category.color)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Circle()
                    .fill(complaint.resolved ? Color.green : statusColor(complaint.status))
                    .frame(width: 11, height: 11)
                    .overlay(
                        Circle()
                            .stroke(Color(.secondarySystemGroupedBackground), lineWidth: 1.5)
                    )
                    .offset(x: 2, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(complaint.desc ?? "No description provided")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(complaint.status ?? "Unknown")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(statusColor(complaint.status))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(statusColor(complaint.status).opacity(0.08))
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: complaint.resolved ? "checkmark.seal.fill" : "clock")
                            .font(.caption2)
                        Text(complaint.resolved ? "Resolved" : "Active Ticket")
                            .font(.system(.footnote, design: .rounded))
                    }
                    .foregroundColor(complaint.resolved ? .green : .secondary)
                    
                    if complaint.image != nil {
                        HStack(spacing: 3) {
                            Image(systemName: "paperclip")
                                .font(.caption2)
                            Text("Attachment")
                                .font(.system(size: 11, design: .rounded))
                        }
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(4)
                    }
                }
            }
        }
        .padding(.all, 16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
    
    private func statusColor(_ status: String?) -> Color {
        switch status?.lowercased() {
        case "pending", "open":
            return .orange
        case "in progress", "inprogress":
            return .blue
        case "resolved", "done":
            return .green
        default:
            return .secondary
        }
    }
}
