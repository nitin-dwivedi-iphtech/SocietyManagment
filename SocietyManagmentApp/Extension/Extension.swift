//
//  Extension.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import CoreData
import SwiftUI

extension Profile{
    static func createDummyProfile(viewContext: NSManagedObjectContext) throws {
        let profile = Profile(context: viewContext)
        profile.name = "Nitin Dwivedi"
        profile.dob = Date()
        profile.emergency_no = "14784562358"
        profile.family_members = 4
        profile.flat_no = "197/85"
        profile.id = UUID()
        
        try viewContext.save()
        
    }
}

extension Visitor{
    static func createDummyVisitor(viewContext: NSManagedObjectContext) throws {
        let dummyData = [
            (name: "John Doe", flat: "A-101", phone: "+1 555-0199", purpose: "Amazon Delivery", vehicle: "NY-1234", inside: true, address: "123 Main St"),
            (name: "Jane Smith", flat: "B-304", phone: "+1 555-0143", purpose: "Family Visit", vehicle: "CA-5678", inside: true, address: "456 Oak Ave"),
            (name: "Bob Builder", flat: "C-512", phone: "+1 555-0182", purpose: "AC Maintenance", vehicle: "TX-9012", inside: false, address: "789 Pine Rd"),
            (name: "Alice Johnson", flat: "A-202", phone: "+1 555-0155", purpose: "FedEx Courier", vehicle: "FL-3456", inside: false, address: "321 Elm St"),
            (name: "Charlie Brown", flat: "D-108", phone: "+1 555-0111", purpose: "Friend", vehicle: "WA-7890", inside: true, address: "654 Spruce Ln")
        ]
        
        for (index, data) in dummyData.enumerated() {
            let visitor = Visitor(context: viewContext)
            
            visitor.id = UUID()
            visitor.name = data.name
            visitor.flat_no = data.flat
            visitor.phone = data.phone
            visitor.purpose = data.purpose
            visitor.vehicle_no = data.vehicle
            visitor.inside = data.inside
            visitor.address = data.address
            
            visitor.arrival_time = Date().addingTimeInterval(TimeInterval(-3600 * index))
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save dummy data: \(error.localizedDescription)")
        }
    }
}

