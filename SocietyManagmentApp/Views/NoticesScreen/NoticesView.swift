//
//  NoticesView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct NoticesView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedNoticeEnum:NoticesEnum = .all
    @State var showAddNotice:Bool = false
    @ObservedObject var profile:Profile
    
    var notices:FetchedResults<Notices>
    var events:FetchedResults<Events>
    
    var filteredNotices: [Notices] {
        if selectedNoticeEnum == .all {
            return Array(notices)
        } else if selectedNoticeEnum == .events {
            return []
        } else {
            return notices.filter { $0.category == selectedNoticeEnum.rawValue }
        }
    }
    
    var filteredEvents: [Events] {
        if selectedNoticeEnum == .all || selectedNoticeEnum == .events {
            return Array(events)
        } else {
            return []
        }
    }
    
    var isListEmpty: Bool {
        filteredNotices.isEmpty && filteredEvents.isEmpty
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                NoticesHeaderView(onCloseTap: {dismiss()}, onAddTap: {showAddNotice=true})
                    .frame(maxWidth:.infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(NoticesEnum.allCases){ notice in
                            NoticesPillView( selected: selectedNoticeEnum == notice, title: notice.rawValue, onNoticePillTap: {
                                selectedNoticeEnum = notice
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, -16)
                
                if isListEmpty {
                    ContentUnavailableView(
                        "No Announcements",
                        systemImage: "bell.slash",
                        description: Text("There are no notices or events in this category right now.")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredNotices) { notice in
                            NavigationLink(destination: NoticeDetailView(notice: notice)) {
                                NoticeCardView(notice: notice)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteItem(notice)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        
                        ForEach(filteredEvents) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventCardView(event: event)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteItem(event)
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
        .sheet(isPresented:$showAddNotice){
            NoticesAddView(profile:profile)
        }
    }
    
    private func deleteItem<T: NSManagedObject>(_ item: T) {
        withAnimation {
            viewContext.delete(item)
            viewContext.saveData()
        }
    }
}

struct NoticesHeaderView: View {
    var onCloseTap: () -> Void
    var onAddTap: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: { onCloseTap() }) {
                Image(systemName:"chevron.left")
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
                Image(systemName:"plus")
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

struct NoticesPillView:View{
    
    var selected:Bool
    var title:String
    
    var onNoticePillTap: () -> Void
    
    var body: some View{
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


//#Preview {
//    NoticesView()
//}
