//
//  Extension.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
internal import CoreData

extension NSManagedObjectContext {
    func saveData() {
        guard self.hasChanges else { return }
        do {
            try self.save()
        } catch {
            print("Error: Core Data context could not be saved. \(error.localizedDescription)")
        }
    }
}

extension Profile {
    static func createDummyProfile(viewContext: NSManagedObjectContext) throws {
        let profile = Profile(context: viewContext)
        profile.name = "Nitin Dwivedi"
        profile.dob = Date()
        profile.emergency_no = "14784562358"
        profile.family_members = 4
        profile.flat_no = "197/85"
        profile.id = UUID()
        
        viewContext.saveData()
    }
}

extension Visitor {
    static func createDummyVisitor(viewContext: NSManagedObjectContext) throws {
        let twoHoursAgo = Date().addingTimeInterval(-7200)
        let twoHoursAhead = Date().addingTimeInterval(7200)
        
        let dummyData = [
            (name: "John Doe", flat: "A-101", phone: "+1 555-0199", purpose: "Amazon Delivery", vehicle: "NY-1234", inside: true, arrival: Date(), address: "123 Main St", exited:false),
            (name: "Jane Smith", flat: "B-304", phone: "+1 555-0143", purpose: "Family Visit", vehicle: "CA-5678", inside: true, arrival: Date(), address: "456 Oak Ave", exited:false),
            (name: "Bob Builder", flat: "C-512", phone: "+1 555-0182", purpose: "AC Maintenance", vehicle: "TX-9012", inside: false, arrival: twoHoursAhead, address: "789 Pine Rd", exited:false),
            (name: "Alice Johnson", flat: "A-202", phone: "+1 555-0155", purpose: "FedEx Courier", vehicle: "FL-3456", inside: false, arrival: twoHoursAgo, address: "321 Elm St", exited:true),
            (name: "Charlie Brown", flat: "D-108", phone: "+1 555-0111", purpose: "Friend", vehicle: "WA-7890", inside: true, arrival: Date(), address: "654 Spruce Ln", exited:false)
        ]
        
        for data in dummyData {
            let visitor = Visitor(context: viewContext)
            
            visitor.id = UUID()
            visitor.name = data.name
            visitor.flat_no = data.flat
            visitor.phone = data.phone
            visitor.purpose = data.purpose
            visitor.vehicle_no = data.vehicle
            visitor.inside = data.inside
            visitor.address = data.address
            visitor.arrival_time = data.arrival
            visitor.exited = data.exited
        }
        
        viewContext.saveData()
    }
}

extension Complaint {
    static func createDummyComplaint(context: NSManagedObjectContext) throws {
        let sampleComplaints = [
            (
                desc: "Elevator in Block B is making a loud grinding noise and stopping unevenly between floors.",
                status: "Pending",
                resolved: false
            ),
            (
                desc: "Water leakage from the ceiling in the kitchen area, coming from the apartment upstairs (A-402).",
                status: "In Progress",
                resolved: false
            ),
            (
                desc: "Streetlight near the main gate / visitor parking area has been flickering completely off since last night.",
                status: "Resolved",
                resolved: true
            ),
            (
                desc: "Gym air conditioning unit is dripping water onto the wooden floorboards, creating a slipping hazard.",
                status: "Pending",
                resolved: false
            ),
            (
                desc: "Uncollected garbage bins left in the common corridor on the 3rd floor, causing an unpleasant odor.",
                status: "Resolved",
                resolved: true
            )
        ]
        
        for sample in sampleComplaints {
            let complaint = Complaint(context: context)
            complaint.id = UUID()
            complaint.personId = UUID() 
            complaint.desc = sample.desc
            complaint.status = sample.status
            complaint.resolved = sample.resolved
        }
        
        context.saveData()
    }
}
