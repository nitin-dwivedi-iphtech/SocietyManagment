//
//  NoticeDetailView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import SwiftUI

struct NoticeDetailView: View {
    let notice: Notices
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text((notice.category ?? "General").uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(notice.isImportant ? Color.red.opacity(0.15) : Color.blue.opacity(0.15))
                        .foregroundColor(notice.isImportant ? .red : .blue)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    if let date = notice.postedDate {
                        Text(date.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text(notice.title ?? "Untitled Notice")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Divider()
                
                Text(notice.body ?? "No content provided.")
                    .font(.body)
                    .lineSpacing(6)
                
                if let author = notice.authorName, !author.isEmpty {
                    Spacer(minLength: 20)
                    HStack {
                        Spacer()
                        Text("Issued by: ")
                            .foregroundStyle(.secondary)
                        Text(author)
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
            }
            .padding()
        }
        .navigationTitle("Notice Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EventDetailView: View {
    let event: Events
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("COMMUNITY EVENT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.purple.opacity(0.15))
                        .foregroundColor(.purple)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                
                Text(event.title ?? "Untitled Event")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let startDate = event.startDate {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundStyle(.purple)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Date & Time")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(startDate.formatted(date: .complete, time: .shortened))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.purple.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Divider()
                
                Text(event.details ?? "No event details available.")
                    .font(.body)
                    .lineSpacing(6)
            }
            .padding()
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
