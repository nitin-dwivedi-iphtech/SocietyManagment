//
//  Persistence.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

internal import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SocietyManagmentApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        addDummyData(container.viewContext)
    }
    
    /*
        add dummy data for whole app
    */
     private func addDummyData(_ context: NSManagedObjectContext) {
        
        let request:NSFetchRequest<Profile> = NSFetchRequest<Profile>(entityName: "Profile")
        let visitorRequest:NSFetchRequest<Visitor> = NSFetchRequest<Visitor>(entityName: "Visitor")
        let complainRequest:NSFetchRequest<Complaint> = NSFetchRequest<Complaint>(entityName: "Complaint")
        request.fetchLimit = 1
        do{
            try Profile.createDummyProfile(viewContext: context)
            if try context.count(for: visitorRequest) == 0{
                try Visitor.createDummyVisitor(viewContext: context)
            }
            if try context.count(for: complainRequest) == 0{
                try Complaint.createDummyComplaint(context: context)
            }
        } catch{
            print("dummy data is not initalized")
        }
    }
}
