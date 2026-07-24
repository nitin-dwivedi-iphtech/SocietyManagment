//
//  VisitorViewModel.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 24/07/26.
//

import SwiftUI
import CoreData

@Observable
class VisitorViewModel {
    var visitors: [Visitor] = [] 
    var searchText: String = ""
    var selectedPill: VisitorEnum = .all
    var showAddVisitor: Bool = false

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        fetchVisitors()
    }

    func fetchVisitors() {
        let request: NSFetchRequest<Visitor> = NSFetchRequest(entityName: "Visitor")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Visitor.arrival_time, ascending: false)]
        visitors = [] // forcing to update ui
        visitors = (try? viewContext.fetch(request)) ?? []
    }

    var filteredVisitors: [Visitor] {
        switch selectedPill {
        case .all:
            return visitors
        case .expected:
            return visitors.filter { !$0.inside && !$0.exited}
        case .inside:
            return visitors.filter { $0.inside && !$0.exited }
        case .exited:
            return visitors.filter { !$0.inside && $0.exited }
        }
    }

    var searchFilteredVisitors: [Visitor] {
        guard !searchText.isEmpty else { return filteredVisitors }
        let lowercasedQuery = searchText.lowercased()
        return filteredVisitors.filter { $0.name?.lowercased().contains(lowercasedQuery) ?? false }
    }

    var insideVisitorsCount: Int {
        visitors.filter { $0.inside }.count
    }

    func dynamicCount(for filter: VisitorEnum) -> Int {
        switch filter {
        case .all:
            return visitors.count
        case .expected:
            return visitors.filter { !$0.inside && !$0.exited  }.count
        case .inside:
            return visitors.filter { $0.inside && !$0.exited }.count
        case .exited:
            return visitors.filter { !$0.inside && $0.exited  }.count
        }
    }

    func markEntry(visitor: Visitor) {
        withAnimation(.spring()) {
            visitor.inside = true
            visitor.exited = false
            viewContext.saveData()
        }
        fetchVisitors()
    }

    func markExit(visitor: Visitor) {
        withAnimation(.spring()) {
            visitor.inside = false
            visitor.exited = true
            viewContext.saveData()
        }
        fetchVisitors()
    }

    func addVisitor(name: String, phone: String, purpose: String, vehicleNo: String, flatNo: String, inside: Bool, address: String, arrivalTime: Date) {
        let visitor = Visitor(context: viewContext)
        visitor.id = UUID()
        visitor.name = name
        visitor.phone = phone
        visitor.purpose = purpose
        visitor.vehicle_no = vehicleNo
        visitor.flat_no = flatNo
        visitor.inside = inside
        visitor.address = address
        visitor.arrival_time = arrivalTime
        visitor.exited = false
        viewContext.saveData()
        fetchVisitors()
    }
}
