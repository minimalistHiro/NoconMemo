//
//  Setting.swift
//  NoconMemo
//
//  Created by 金子広樹 on 2023/08/04.
//

import SwiftUI

final class Setting {
    // 各種設定
    let maxTextCount: Int = 10000                           // 最大テキスト文字数
    let maxListCount: Int = 300                             // 最大リスト数
    
    // 固定色
    let black: Color = Color("Black")                       // 文字・ボタン色
    let white: Color = Color("White")                       // 背景色
    let highlight: Color = Color("Highlight")               // 強調色
}
