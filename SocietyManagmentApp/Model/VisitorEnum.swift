//
//  VisitorEnum.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI

enum VisitorEnum: String, CaseIterable, Identifiable {
    case all = "All"
    case expected = "Expected"
    case inside = "Inside"
    case exited = "Exited"
    
    var id:String{ self.rawValue }
    
    var count: Int{
        switch self {
        case .all: return 5
        case .expected : return 2
        case .inside : return 1
        case .exited : return 2
        }
    }
    
}
