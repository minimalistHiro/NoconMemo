//
//  ListView.swift
//  NoconMemo
//
//  Created by 金子広樹 on 2023/08/04.
//

import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entity.createDate, ascending: true)])
    var data: FetchedResults<Entity>
    
    let setting = Setting()
    
    var body: some View {
        
        let mappedText = data.map { value in
            value.text
        }
        
        NavigationStack {
            List {
                ForEach(data) { data in
                    if let text = data.text {
                        if !text.isEmpty {
                            NavigationLink {
                                DraftView(data: data, editedText: text)
                            } label: {
                                Text(prefixText(text))
                                    .font(.system(size: 25))
                                    .lineLimit(1)
                            }
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    rowRemove(data: data)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
            }
            .listStyle(.inset)
            .environment(\.defaultMinListRowHeight, 70)
            .padding()
            .overlay(alignment: .bottomTrailing) {
                // プラスボタン
                if mappedText.count <= setting.maxListCount - 1 {
                    NavigationLink {
                        NewTextView()
                    } label: {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .foregroundColor(setting.black)
                            .overlay {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .bold()
                                    .foregroundColor(setting.white)
                            }
                    }
                    .padding(30)
                }
            }
        }
        .onAppear {
            for data in data {
                if let text = data.text {
                    // テキストが空の場合、削除する。
                    if text.isEmpty {
                        rowRemove(data: data)
                    }
                }
            }
//            print("onAppear: \(data.count)")
        }
        .onChange(of: mappedText) { _ in
            for data in data {
                if let text = data.text {
                    // テキストが空の場合、削除する。
                    if text.isEmpty {
                        rowRemove(data: data)
                    }
                }
            }
//            print("onChange: \(data.count)")
        }
    }
    
    /// メモテキストを、リストに表示する用に簡略化したテキストに変換する。
    /// - Parameters:
    ///   - text: メモテキスト
    /// - Returns: リストに表示する用に簡略化したテキスト
    private func prefixText(_ text: String) -> String {
        if let index = text.firstIndex(of: "\n") {
            let prefix = text.prefix(upTo: index)
            return String(prefix)
        }
        return text
    }
    
    /// 行を削除する。
    /// - Parameters:
    ///   - data: 削除するデータ
    /// - Returns: なし
    private func rowRemove(data: FetchedResults<Entity>.Element) {
        viewContext.delete(data)
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
