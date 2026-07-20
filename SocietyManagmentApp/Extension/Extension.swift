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

extension Date {
    func toMonthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
}

extension String {
    func toMonthYearDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.date(from: self)
    }
}
extension Profile {
    static func createDummyProfile(viewContext: NSManagedObjectContext) throws {
        // 1. CREATE THE PROFILE CARD
        let profile = Profile(context: viewContext)
        let residentId = UUID()
        
        profile.id = residentId
        profile.name = "Nitin Dwivedi"
        profile.flat_no = "B-545"
        profile.family_members = 4
        profile.emergency_no = "14784562358"
        profile.dob = Calendar.current.date(from: DateComponents(year: 1995, month: 8, day: 15))
        profile.phone = "8452145985"
        
        // 2. GENERATE MAINTENANCE RECORDS
        let recordsData: [(month: String, amount: Double, status: String, dueDay: Int, dueMonth: Int, isPaid: Bool, receipt: String?)] = [
            ("July 2026", 3500.0, "Unpaid", 10, 7, false, nil),
            ("June 2026", 3500.0, "Paid", 10, 6, true, "REC-2026-0699"),
            ("May 2026", 3500.0, "Paid", 10, 5, true, "REC-2026-0542"),
            ("April 2026", 3200.0, "Paid", 10, 4, true, "REC-2026-0411")
        ]
        
        for record in recordsData {
            let maintenance = Maintenance(context: viewContext)
            maintenance.id = UUID()
            maintenance.personId = residentId
            maintenance.billMonth = record.month.toMonthYearDate()  ?? Date()
            maintenance.amount = record.amount
            maintenance.status = record.status
            
            var dueComponents = DateComponents()
            dueComponents.year = 2026
            dueComponents.month = record.dueMonth
            dueComponents.day = record.dueDay
            maintenance.dueDate = Calendar.current.date(from: dueComponents)
            maintenance.isPaid = record.isPaid
            
            if record.isPaid {
                maintenance.receiptNo = record.receipt
                maintenance.transactionId = UUID()
                
                var payComponents = DateComponents()
                payComponents.year = 2026
                payComponents.month = record.dueMonth
                payComponents.day = record.dueDay - 2
                maintenance.paymentDate = Calendar.current.date(from: payComponents)
            }
            
            maintenance.profile_maintain_relation = profile
        }
        
        // GENERATE THE AMENITIES
        let createdAmenities = generateAmenities(viewContext: viewContext)
        
        // GENERATE DUMMY BOOKINGS
        generateBookings(createdAmenities: createdAmenities, viewContext: viewContext, profile: profile)
        
        viewContext.saveData()
    }
}

func generateBookings(createdAmenities:[String: Amenities], viewContext: NSManagedObjectContext, profile:Profile){
    let today = Date()
    
    let sampleSlots: [StandardSlots] = [
        .slot1,
        .slot3,
    ]
    
    for (_, amenity) in createdAmenities {
        
        for slot in sampleSlots {
            let booking = Bookings(context: viewContext)
            booking.id = UUID()
            booking.amenityId = amenity.id
            booking.profileId = profile.id
            booking.isExpired = false
            
            booking.bookingDate = today
            booking.timeSlot = slot.rawValue
            
            booking.booking_amenities_relation = amenity
            booking.booking_profile_relation = profile
        }
    }
}

func generateAmenities(viewContext:NSManagedObjectContext)->  [String: Amenities]{
    let amenitiesConfig = [
        (name: "gym", address: "Clubhouse 1st Floor"),
        (name: "pool", address: "Clubhouse Ground Floor Courtyard"),
        (name: "club", address: "Main Clubhouse Grand Hall")
    ]
    
    var createdAmenities: [String: Amenities] = [:]
    
    for config in amenitiesConfig {
        let amenity = Amenities(context: viewContext)
        amenity.id = UUID()
        amenity.name = config.name
        amenity.address = config.address
        
        createdAmenities[config.name] = amenity
    }
    return createdAmenities
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
