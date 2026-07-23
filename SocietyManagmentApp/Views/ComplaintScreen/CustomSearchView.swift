//
//  CustomSearchView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI

struct CustomSearchView: View {
    @Binding var searchText:String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search...", text: $searchText)
                .font(.system(.body, design: .rounded))
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

