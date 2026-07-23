//
//  NoticeEventsView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
import CoreData

struct NoticeEventsRowView: View {
    @State var showNoticesView: Bool = false
    @ObservedObject var profile: Profile
    @EnvironmentObject var noticesVM: NoticesViewModel

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
                    .onTapGesture {
                        showNoticesView = true
                    }
            }
            .padding(.horizontal)

            NoticesCardView(notices: noticesVM.notices)
            EventsCardView(events: noticesVM.events)
        }
        .padding(.vertical)
        .sheet(isPresented: $showNoticesView) {
            NoticesView(profile: profile)
        }
    }
}

struct NoticesCardView: View {
    var notices: [Notices]

    var displayNotices: [Notices] {
        Array(notices.prefix(2))
    }

    var body: some View {
        VStack(spacing: 0) {
            if displayNotices.isEmpty {
                Text("No recent notices.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(Array(displayNotices.enumerated()), id: \.element) { index, notice in
                    NoticeCardRowView(notices: notice)

                    if index < displayNotices.count - 1 {
                        Divider()
                            .padding(.leading, 50)
                    }
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

struct EventsCardView: View {
    var events: [Events]

    var displayEvents: [Events] {
        Array(events.prefix(2))
    }

    var body: some View {
        VStack(spacing: 0) {
            if displayEvents.isEmpty {
                Text("No upcoming events.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(Array(displayEvents.enumerated()), id: \.element) { index, event in
                    EventsCardRowView(event: event)

                    if index < displayEvents.count - 1 {
                        Divider()
                            .padding(.leading, 50)
                    }
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

struct NoticeCardRowView: View {
    var notices: Notices

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "bell.fill")
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(notices.body ?? "N/A")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(notices.postedDate ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

struct EventsCardRowView: View {
    var event: Events

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "party.popper.fill")
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(width: 36, height: 36)
                .background(Color.purple.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(event.details ?? "N/A")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(event.startDate ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }
}
