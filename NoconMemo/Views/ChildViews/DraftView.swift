//
//  DraftView.swift
//  NoconMemo
//
//  Created by 金子広樹 on 2023/08/04.
//

import SwiftUI

struct DraftView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    let setting = Setting()
    @FocusState private var focus: Bool
    let data: FetchedResults<Entity>.Element
    @State var editedText: String                       // 編集用テキスト
    @State private var isShowDeleteAlert: Bool = false  // 削除アラート表示有無
    
    var body: some View {
        NavigationStack {
            TextEditor(text: $editedText)
                .lineSpacing(5)
                .padding()
                .focused($focus, equals: true)
                .onChange(of: editedText) { text in
                    // 最大文字数に達したら、それ以上書き込めないようにする。
                    if text.count > setting.maxTextCount {
                        editedText.removeLast(editedText.count - setting.maxTextCount)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            if !editedText.isEmpty {
                                Button {
                                    isShowDeleteAlert = true
                                } label: {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25)
                                        .foregroundColor(setting.black)
                                }
                            }
                            Spacer()
                        }
                    }
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            // 何故か空白のボタンを入れないとチェックマークが表示されなくなるので仕方なく入れている。
                            Button { } label: { }
                            Spacer()
                            // 完了ボタン
                            Button {
                                focus = false
                            } label: {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .foregroundColor(setting.black)
                            }
                        }
                    }
                }
        }
        // 戻るボタンの独自実装
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .bold()
                        .foregroundColor(setting.black)
                }
            }
        }
        .alert("", isPresented: $isShowDeleteAlert) {
            Button("削除", role: .destructive) {
                editedText = ""
            }
            Button("キャンセル", role: .cancel) {
                isShowDeleteAlert = false
            }
        } message: {
            Text("全て削除しますか？")
        }
        .onDisappear {
            update()
        }
    }
    
    /// textを更新する。
    /// - Parameters: なし
    /// - Returns: なし
    private func update() {
        data.text = editedText
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
    }
}

//struct DraftView_Previews: PreviewProvider {
//    static var previews: some View {
//        DraftView(editedText: "タイトル", isNewText: false)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
