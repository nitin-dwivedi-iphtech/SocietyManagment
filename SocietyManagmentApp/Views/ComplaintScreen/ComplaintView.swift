//
//  ComplaintView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI
internal import CoreData

struct ComplaintView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedFilter: ComplaintEnum = .all
    @State var showAddComplaint: Bool = false
    @ObservedObject var profile: Profile
    @State private var selectedComplaint: Complaint? = nil
    @State private var searchText:String = ""
    
    @State private var refreshTrigger: Bool = false
    
    var complaints: FetchedResults<Complaint>
    
    var filteredComplaints: [Complaint] {
        let _ = refreshTrigger
        let cleanArray = Array(complaints)
        
        switch selectedFilter {
        case .all:
            return cleanArray
        case .open:
            return cleanArray.filter { $0.status?.lowercased() == "pending" || $0.status?.lowercased() == "open" }
        case .inProgress:
            return cleanArray.filter { $0.status?.lowercased() == "in progress" || $0.status?.lowercased() == "inprogress" }
        case .done:
            return cleanArray.filter { $0.status?.lowercased() == "resolved" || $0.status?.lowercased() == "done" }
        }
    }
    
    var searchFilteredComplaints: [Complaint] {
        let _ = refreshTrigger
        guard !searchText.isEmpty else { return filteredComplaints }
        
        let query = searchText.lowercased()
        
        return filteredComplaints.filter { complaint in
            
            let categoryMatches = complaint.category?.lowercased().contains(query) ?? false
            
            let descMatches = complaint.desc?.lowercased().contains(query) ?? false
            
            return categoryMatches || descMatches
        }
    }
    
    private var openCount: Int {
        complaints.filter { !$0.resolved }.count
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Complaints")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("\(openCount) open Complaints")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: {
                    showAddComplaint = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            CustomSearchView(searchText: $searchText)
            ComplaintPillView(selectedFilter: $selectedFilter)
            
            List {
                ForEach(searchFilteredComplaints) { complaint in
                    ComplainListView(complaint: complaint)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 6)
                        .onTapGesture {
                            selectedComplaint = complaint
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if !complaint.resolved {
                                Button {
                                    withAnimation {
                                        complaint.resolved = true
                                        complaint.status = "Resolved"
                                        viewContext.saveData()
                                        refreshTrigger.toggle()
                                    }
                                } label: {
                                    Label("Resolve", systemImage: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                        }
                }
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .sheet(isPresented: $showAddComplaint) {
            AddComplaintView(profile: profile)
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(item: $selectedComplaint) { complaint in
            ComplaintDetailView(complaint: complaint)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}



struct ComplaintPillView: View {
    @Binding var selectedFilter: ComplaintEnum
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ComplaintEnum.allCases) { complaint in
                    ComplaintPillTextView(title: complaint.rawValue, isSelectedPill: selectedFilter == complaint)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                selectedFilter = complaint
                            }
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}

struct ComplaintPillTextView: View {
    var title: String = ""
    var isSelectedPill: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .foregroundStyle(isSelectedPill ? .white : .secondary)
            .background(
                isSelectedPill ? Color.blue : Color(.secondarySystemGroupedBackground),
                in: Capsule()
            )
            .shadow(color: isSelectedPill ? .blue.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
    }
}
