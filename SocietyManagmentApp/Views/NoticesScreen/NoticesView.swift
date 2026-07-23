//
//  NoticesView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import SwiftUI
import CoreData

struct NoticesView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var profile: Profile

    @EnvironmentObject var viewModel: NoticesViewModel

    var body: some View {
        NavigationStack {
            VStack {
                NoticesHeaderView(onCloseTap: { dismiss() }, onAddTap: { viewModel.showAddNotice = true })
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(NoticesEnum.allCases) { notice in
                            NoticesPillView(selected: viewModel.selectedNoticeEnum == notice, title: notice.rawValue, onNoticePillTap: {
                                viewModel.selectedNoticeEnum = notice
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, -16)

                if viewModel.isListEmpty {
                    ContentUnavailableView(
                        "No Announcements",
                        systemImage: "bell.slash",
                        description: Text("There are no notices or events in this category right now.")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredNotices) { notice in
                            NavigationLink(destination: NoticeDetailView(notice: notice)) {
                                NoticeCardView(notice: notice)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteItem(notice)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }

                        ForEach(viewModel.filteredEvents) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventCardView(event: event)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteItem(event)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }

                    }
                    .listStyle(.inset)
                    .scrollContentBackground(.hidden)
                }

                Spacer()
            }
        }
        .padding()
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showAddNotice) {
            NoticesAddView(profile: profile)
        }
    }
}

struct NoticesHeaderView: View {
    var onCloseTap: () -> Void
    var onAddTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: { onCloseTap() }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(Color(.secondarySystemBackground), in: Circle())
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Notices")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Society announcements & events")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: { onAddTap() }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.blue, in: Circle())
                    .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct NoticesPillView: View {

    var selected: Bool
    var title: String

    var onNoticePillTap: () -> Void

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .foregroundStyle(selected ? .white : .secondary)
            .background(
                selected ? Color.blue : Color(.secondarySystemGroupedBackground),
                in: Capsule()
            )
            .shadow(color: selected ? .blue.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
            .onTapGesture {
                onNoticePillTap()
            }
    }
}
