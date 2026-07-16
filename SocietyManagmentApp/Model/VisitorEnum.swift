//
//  VisitorEnum.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI

// for navigation
enum VisitorEnum: String, CaseIterable, Identifiable {
    case all = "All"
    case expected = "Expected"
    case inside = "Inside"
    case exited = "Exited"
    
    var id: String { self.rawValue }
}
