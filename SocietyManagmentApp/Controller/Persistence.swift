//
//  Persistence.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import CoreData

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
    
    private func addDummyData(_ context: NSManagedObjectContext) {
        
        let request:NSFetchRequest<Profile> = NSFetchRequest<Profile>(entityName: "Profile")
        request.fetchLimit = 1
        do{
            try Profile.createDummyProfile(viewContext: context)
            try Visitor.createDummyVisitor(viewContext: context)
        } catch{
            print("dummy data is not initalized")
        }
    }
}
