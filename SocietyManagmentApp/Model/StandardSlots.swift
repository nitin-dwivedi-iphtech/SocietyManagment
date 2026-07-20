//
//  StandardTime.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 20/07/26.
//

enum StandardSlots: String, Identifiable, CaseIterable{
    case slot1 = "06:00 AM - 07:00 AM"
    case slot2 = "07:00 AM - 08:00 AM"
    case slot3 = "08:00 AM - 09:00 AM"
    case slot4 = "09:00 AM - 10:00 AM"
    case slot5 = "05:00 PM - 06:00 PM"
    
    var id:String{ self.rawValue }
    
    func getTargetHour()->Int{
        switch self {
        case .slot1: return 6
        case .slot2: return  7
        case .slot3: return  8
        case .slot4: return  9
        case .slot5: return  17
        }
    }
    
    static var maxCapacity:Int { 5 }
}
