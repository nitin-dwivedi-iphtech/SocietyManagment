//
//  VisitorView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI

struct VisitorView: View {
    
    var visitors: FetchedResults<Visitor>
    @State private var searchText: String = ""
    @State var selectedPill:VisitorEnum = .all
    
    var body: some View {
        VStack(alignment:.leading){
            VStack(alignment:.leading){
                Text("Visitors")
                    .font(.title)
                    .bold()
                Text("1 currently inside")
                
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(VisitorEnum.allCases) { filter in
                        PillView(title: filter.id, count: filter.count, isSelected: selectedPill == filter)
                            .onTapGesture{
                                selectedPill = filter
                            }
                    }
                }
            }.padding(.vertical,10)
            
            ScrollView{
                VStack{
                    ForEach(visitors) { visitor in
                        VisitorListView(visitor: visitor)
                        
                    }
                }
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct VisitorListView: View {
    @ObservedObject var visitor: Visitor
    
    var body: some View {
        HStack(spacing: 12) {
            // Status Indicator (Green for Inside, Gray for Checked Out)
            Circle()
                .fill(visitor.inside ? Color.green : Color.gray.opacity(0.6))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    // Visitor Name
                    Text(visitor.name ?? "Unknown Visitor")
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Flat Number Tag
                    Text(visitor.flat_no ?? "N/A")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                // Purpose of Visit
                Text("Purpose: \(visitor.purpose ?? "N/A")")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                // Vehicle Number (if available)
                if let vehicleNo = visitor.vehicle_no, !vehicleNo.isEmpty {
                    Text("Vehicle: \(vehicleNo)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            // Arrival Time Format
            if let arrivalTime = visitor.arrival_time {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(arrivalTime, style: .time)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(arrivalTime, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 2)
    }
}

struct PillView: View {
    var title: String
    var count: Int
    var isSelected:Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
            
            Text("\(count)")
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white)
                .clipShape(Capsule())
                .foregroundColor(.blue)
        }
        .frame(minWidth:80)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(isSelected ? Color.blue : Color.gray)
        .clipShape(Capsule())
    }
}

//#Preview {
//    let visitor = Visitor()
//    VisitorView(visitors: visitor)
//}
