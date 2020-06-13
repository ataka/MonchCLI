//
//  Reviewer.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

struct Reviewer: Decodable {
    let name: String
    let chatworkId: Int
    let githubLogin: String

    func isValid() -> Bool {
        guard !name.isEmpty else {
            fatalError("Reviewer の名前が空です。設定ファイルを確認してください。")
        }
        guard !githubLogin.isEmpty else {
            fatalError("Reviewer の GitHub の名前が空です。設定ファイルを確認してください。")
        }
        return true
    }
}
