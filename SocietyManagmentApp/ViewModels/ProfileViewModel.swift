//
//  ProfileViewModel.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 24/07/26.
//

import SwiftUI
import CoreData

@Observable
class ProfileViewModel {
    var profile: Profile?
    var showBookingsSheet: Bool = false

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchProfile()
    }

    func fetchProfile() {
        let request: NSFetchRequest<Profile> = NSFetchRequest(entityName: "Profile")
        profile = try? viewContext.fetch(request).first
    }


    var firstLetter: String {
        String((profile?.name as String? ?? "?").prefix(1)).uppercased()
    }

    var name: String {
        profile?.name as String? ?? "Guest User"
    }

    var flatNo: String {
        profile?.flat_no as String? ?? "N/A"
    }

    var phone: String? {
        profile?.phone as String?
    }

    var emergencyNo: String? {
        profile?.emergency_no as String?
    }

    var familyMembers: Int {
        Int(profile?.family_members ?? 0)
    }

    var dobFormatted: String {
        (profile?.dob as Date?)?.formatted(date: .long, time: .omitted) ?? "Not Added"
    }

    func callPhone(_ phoneNumber: String?) {
        guard let number = phoneNumber, !number.isEmpty,
              let url = URL(string: "tel://\(number)"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
