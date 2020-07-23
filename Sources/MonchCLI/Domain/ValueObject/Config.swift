//
//  Config.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/30.
//

import Foundation

struct Config {
    let chatwork: Chatwork
    let github: Github
    let reviewers: [Reviewer]
    let customQueries: [CustomQuery]

    func validate() throws {
        try chatwork.validate()
        try github.validate()
        try reviewers.forEach {
            try $0.validate()
        }
        try customQueries.forEach {
            try $0.validate()
        }
    }
}

extension Config {
    struct Chatwork {
        let token: String
        let roomId: Int

        func validate() throws {
            guard !token.isEmpty       else { throw(ConfigFileError.chatworkTokenEmpty) }
            guard token.isAlphaNumeric else { throw(ConfigFileError.chatworkTokenWrongCharacter) }
            return
        }
    }
}

extension Config {
    struct Github {
        let token: String
        let repository: String

        func validate() throws {
            guard !token.isEmpty       else { throw(ConfigFileError.gitHubTokenEmpty) }
            guard token.isAlphaNumeric else { throw(ConfigFileError.gitHubTokenWrongCharacter) }
            return
        }
    }
}

// MARK: - Validation Extension

private extension String {
    var isAlphaNumeric: Bool {
        range(of: "[^[:alnum:]]", options: .regularExpression) == nil
    }
}
