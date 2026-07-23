//
//  AmenitiesEnum.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 20/07/26.
//

import SwiftUI

enum AmenitiesEnum: String, CaseIterable, Identifiable{
    case gym = "GYM"
    case pool = "POOL"
    case club = "Club"
    
    var id:String{ self.rawValue }
    
    func iconName(for amenity: AmenitiesEnum) -> String {
        switch amenity {
        case .gym: return "dumbbell.fill"
        case .pool: return "figure.pool.swim"
        case .club: return "fork.knife"
        }
    }
    
    func buttonColor(for amenity:AmenitiesEnum) -> Color{
        switch amenity{
        case .gym: return .blue
        case .pool: return .green
        case .club: return .purple
        }
    }
    
    func image(for amenity: AmenitiesEnum) -> String{
        switch amenity{
        case .gym: return "gym"
        case .club: return "club_house"
        case .pool: return "swiming"
        }
    }
}
