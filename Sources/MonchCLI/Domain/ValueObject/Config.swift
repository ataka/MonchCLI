//
//  Config.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/30.
//

import Foundation

struct Config: Decodable {
    let chatwork: Chatwork
    let github: Github
    let reviewers: [Reviewer]
}

extension Config {
    struct Chatwork: Decodable {
        let token: String
        let roomId: Int
    }
}

extension Config {
    struct Github: Decodable {
        let token: String
        let repository: String
    }
}

extension Config {
    struct Reviewer: Decodable {
        let name: String
        let chatworkId: Int
        let githubLogin: String
    }
}
