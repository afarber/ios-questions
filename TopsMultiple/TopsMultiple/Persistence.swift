//
//  Persistence.swift
//  TopsMultiple
//
//  Created by Alexander Farber on 14.07.21.
//

import CoreData

struct PersistenceController {
    static let shared = [
        "en": PersistenceController(language: "en"),
        "de": PersistenceController(language: "de"),
        "ru": PersistenceController(language: "ru")
    ]

    static var preview: PersistenceController = {
        let result = PersistenceController(language: "en", inMemory: true)
        let viewContext = result.container.viewContext
        for var i in 0..<10 {
            let newTop = TopEntity(context: viewContext)
            newTop.uid = Int32(101 + i)
            newTop.elo = Int32(2500 - i * 100)
            newTop.given = "Person #\(newTop.uid)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    init(language: String, inMemory: Bool = false) {
        container = NSPersistentContainer(name: language)
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
