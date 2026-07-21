//
//  NoticeCardView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import SwiftUI

struct NoticeCardView: View {
    let notice: Notices
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text((notice.category ?? "General").uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(notice.isImportant ? Color.red.opacity(0.15) : Color.blue.opacity(0.15))
                    .foregroundColor(notice.isImportant ? .red : .blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Spacer()
                
                if let date = notice.postedDate {
                    Text(date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text(notice.title ?? "Untitled Notice")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(notice.body ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let author = notice.authorName, !author.isEmpty {
                HStack {
                    Spacer()
                    Text("By \(author)")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct EventCardView: View {
    let event: Events
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("EVENT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.15))
                    .foregroundColor(.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Spacer()
                
                if let start = event.startDate {
                    Text(start.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text(event.title ?? "Untitled Event")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(event.details ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
    }
}
