//
//  PersistenceController.swift
//  NoconMemo
//
//  Created by 金子広樹 on 2023/08/04.
//

import Foundation
import CoreData

struct PersistenceController {
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for num in 0..<5 {
            let newItem = Entity(context: viewContext)
            newItem.createDate = Date().addingTimeInterval(Double(num))
            newItem.text = "text\(num + 1)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
