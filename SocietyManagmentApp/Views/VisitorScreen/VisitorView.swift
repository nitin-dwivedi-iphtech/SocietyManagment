//
//  VisitorView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI
import CoreData

struct VisitorView: View {

    @StateObject private var viewModel = VisitorViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Visitors")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)

                    Text("\(viewModel.insideVisitorsCount) currently inside")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .id("\(viewModel.visitors.count)-\(viewModel.insideVisitorsCount)")
                }
                Spacer()

                Button(action: {
                    viewModel.showAddVisitor = true
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

            CustomSearchView(searchText: $viewModel.searchText)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(VisitorEnum.allCases) { filter in
                        PillView(
                            title: filter.rawValue,
                            count: viewModel.dynamicCount(for: filter),
                            isSelected: viewModel.selectedPill == filter
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.selectedPill = filter
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)

            List {
                ForEach(viewModel.searchFilteredVisitors) { visitor in
                    VisitorListView(visitor: visitor)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if visitor.inside {
                                Button {
                                    viewModel.markExit(visitor: visitor)
                                } label: {
                                    Label("Exit", systemImage: "door.left.hand.open")
                                }
                                .tint(.orange)
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if !visitor.inside && !visitor.exited {
                                Button {
                                    viewModel.markEntry(visitor: visitor)
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
        .sheet(isPresented: $viewModel.showAddVisitor) {
            AddVisitorView()
        }
        .navigationBarHidden(true)
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
