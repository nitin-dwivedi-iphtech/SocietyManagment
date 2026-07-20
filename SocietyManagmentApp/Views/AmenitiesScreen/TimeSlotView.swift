//
//  TimeSlotView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 20/07/26.
//

import SwiftUI

struct TimeSlotView: View {
    var time: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Text(time)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
        }
        .padding()
        .frame(height: 50)
        .background(isSelected ? Color.blue : Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

//#Preview {
//    TimeSlotView()
//}
