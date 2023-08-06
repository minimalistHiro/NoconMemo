//
//  NoconMemoApp.swift
//  NoconMemo
//
//  Created by 金子広樹 on 2023/08/04.
//

import SwiftUI

@main
struct NoconMemoApp: App {
    let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
