//
//  NoticeEventsView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI

struct NoticeEventsRowView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notices & Events")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            NoticeEventsCardView()
        }
        .padding(.vertical)
    }
}

struct NoticeEventsCardView: View {
    let eventDetail = "Annual General Meeting of the Society - July 2026"
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3) { index in
                NoticeEventsCardRowView(eventDetail: eventDetail)
                
                if index < 2 {
                    Divider()
                        .padding(.leading, 50)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

struct NoticeEventsCardRowView: View {
    var eventDetail: String
    var eventDate: Date = Date()
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "party.popper.fill")
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(width: 36, height: 36)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(eventDetail)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(eventDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        NoticeEventsRowView()
    }
}
