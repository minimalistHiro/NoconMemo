//
//  ContentView.swift
//  NoconMemo
//
//  Created by 金子広樹 on 2023/08/04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
