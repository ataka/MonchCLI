//
//  Config.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/30.
//

import Foundation

struct Config: Decodable {
    let chatwork: Chatwork
    let reviewers: [Reviewer]
}

extension Config {
    struct Chatwork: Decodable {
        let token: String
        let roomId: Int
    }
}

extension Config {
    struct Reviewer: Decodable {
        let name: String
        let chatworkId: Int
    }
}
