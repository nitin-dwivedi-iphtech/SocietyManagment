import SwiftUI
internal import CoreData

struct VisitorView: View {
    var visitors: FetchedResults<Visitor>
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText: String = ""
    @State private var selectedPill: VisitorEnum = .all
    @State private var showAddVisitor: Bool = false
    
    @State private var refreshTrigger: Bool = false
    private var filteredVisitors: [Visitor] {
        
        let _ = refreshTrigger
        let cleanArray = Array(visitors)
        
        switch selectedPill {
        case .all:
            return cleanArray
            
        case .expected:
            return cleanArray.filter { !$0.inside && !$0.exited && ($0.arrival_time ?? Date()) >= Date() }
            
        case .inside:
            return cleanArray.filter { $0.inside && !$0.exited }
            
        case .exited:
            return cleanArray.filter { !$0.inside  && $0.exited && ($0.arrival_time ?? Date()) < Date() }
        }
    }
    
    private var searchFilteredVisitors: [Visitor] {
        let _ = refreshTrigger
        guard !searchText.isEmpty else { return filteredVisitors }
        
        let lowercasedQuery = searchText.lowercased()
        
        let filtered: [Visitor] = filteredVisitors.filter {
            $0.name?.lowercased().contains(lowercasedQuery) ?? false
        }
        
        return filtered
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Visitors")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("\(visitors.filter { $0.inside }.count) currently inside")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .id("\(visitors.count)-\(visitors.filter { $0.inside }.count)")
                }
                Spacer()
                
                Button(action: {
                    showAddVisitor = true
                }) {
                    Image(systemName: "person.badge.plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            CustomSearchView(searchText: $searchText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(VisitorEnum.allCases) { filter in
                        PillView(
                            title: filter.rawValue,
                            count: getDynamicCount(for: filter),
                            isSelected: selectedPill == filter
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedPill = filter
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
            
            List {
                ForEach(searchFilteredVisitors) { visitor in
                    VisitorListView(visitor: visitor)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if visitor.inside {
                                Button {
                                    withAnimation(.spring()) {
                                        visitor.inside = false
                                        visitor.exited = true
                                        viewContext.saveData()
                                        refreshTrigger.toggle()
                                    }
                                } label: {
                                    Label("Exit", systemImage: "door.left.hand.open")
                                }
                                .tint(.orange)
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if !visitor.inside && !visitor.exited {
                                Button {
                                    withAnimation(.spring()) {
                                        visitor.inside = true
                                        visitor.exited = false
                                        viewContext.saveData()
                                        refreshTrigger.toggle()
                                    }
                                } label: {
                                    Label("Entry", systemImage: "door.right.hand.open")
                                }
                                .tint(.green)
                            }
                        }
                }
            }
            .listStyle(.plain)
            .background(Color(.systemGroupedBackground).opacity(0.4))
        }
        .sheet(isPresented: $showAddVisitor) {
            AddVisitorView()
        }
        .navigationBarHidden(true)
    }
    
    private func getDynamicCount(for filter: VisitorEnum) -> Int {
        
        let _ = refreshTrigger
        let cleanArray = Array(visitors)
        switch filter {
        case .all:
            return cleanArray.count
        case .expected:
            return cleanArray.filter { !$0.inside && !$0.exited && ($0.arrival_time ?? Date()) >= Date() }.count
        case .inside:
            return cleanArray.filter { $0.inside && !$0.exited }.count
        case .exited:
            return cleanArray.filter { !$0.inside && $0.exited && ($0.arrival_time ?? Date()) < Date() }.count
        }
    }
}


struct PillView: View {
    var title: String
    var count: Int
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
            
            Text("\(count)")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(isSelected ? .white.opacity(0.2) : Color(.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .secondary)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue : Color(.systemBackground))
        .clipShape(Capsule())
        .shadow(color: isSelected ? Color.blue.opacity(0.25) : Color.black.opacity(0.02), radius: 6, x: 0, y: 3)
    }
}
