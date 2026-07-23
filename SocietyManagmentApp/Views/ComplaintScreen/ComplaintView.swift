//
//  ComplaintView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI
import CoreData

struct ComplaintView: View {
    var profileId: UUID

    @StateObject private var viewModel = ComplaintViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Complaints")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)

                    Text("\(viewModel.openComplaintsCount) open complaints")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                Spacer()

                Button(action: {
                    viewModel.showAddComplaint = true
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
            .padding(.horizontal, 20)
            .padding(.top, 16)

            CustomSearchView(searchText: $viewModel.searchText)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ComplaintEnum.allCases) { filter in
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
                ForEach(viewModel.searchFilteredComplaints) { complaint in
                    ComplainListView(complaint: complaint)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            viewModel.selectedComplaint = complaint
                            viewModel.showComplaintDetail = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if !complaint.resolved {
                                Button {
                                    viewModel.resolveComplaint(complaint)
                                } label: {
                                    Label("Resolve", systemImage: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                        }
                }
            }
            .listStyle(.plain)
            .background(Color(.systemGroupedBackground).opacity(0.4))
        }
        .sheet(isPresented: $viewModel.showAddComplaint) {
            AddComplaintView(profileId: profileId)
        }
        .sheet(isPresented: $viewModel.showComplaintDetail) {
            if let complaint = viewModel.selectedComplaint {
                ComplaintDetailView(complaint: complaint)
            }
        }
        .navigationBarHidden(true)
    }
}
