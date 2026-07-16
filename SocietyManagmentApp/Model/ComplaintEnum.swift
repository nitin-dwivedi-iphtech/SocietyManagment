//
//  ComplaintEnum.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 16/07/26.
//

import SwiftUI

// for navigation
enum ComplaintEnum: String, Identifiable, CaseIterable {
    case all = "All"
    case open = "Open"
    case inProgress = "In Progress"
    case done = "Done"
    
    var id: String { self.rawValue }
}

// for category
enum ComplaintCategoryEnum: String, Identifiable, CaseIterable {
    case general = "General"
    case plumbing = "Plumbing"
    case electrical = "Electrical"
    case security = "Security"
    case housekeeping = "Housekeeping"
    case lift = "Lift / Elevator"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .general:
            return "exclamationmark.bubble.fill"
        case .plumbing:
            return "drop.fill"
        case .electrical:
            return "bolt.fill"
        case .security:
            return "shield.fill"
        case .housekeeping:
            return "trash.fill"
        case .lift:
            return "arrow.up.and.down.square.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .general:
            return .gray
        case .plumbing:
            return .blue
        case .electrical:
            return .yellow
        case .security:
            return .red
        case .housekeeping:
            return .green
        case .lift:
            return .purple
        }
    }
}
