//
//  NoticesEnum.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import Foundation

enum NoticesEnum: String, CaseIterable, Identifiable{
    case all = "All"
    case urgent = "Urgent"
    case events = "Events"
    case general = "General"
    
    var id:String{ self.rawValue }
    
}
