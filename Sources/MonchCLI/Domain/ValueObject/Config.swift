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
            guard !token.isEmpty      else { throw(ConfigFileError.gitHubTokenEmpty) }
            guard isValidToken(token) else { throw(ConfigFileError.gitHubTokenWrongCharacter) }
            return
        }

        // https://github.blog/changelog/2021-03-31-authentication-token-format-updates-are-generally-available/
        private func isValidToken(_ token: String) -> Bool {
            token.range(of: "[^A-Za-z0-9_]", options: .regularExpression) == nil
        }
    }
}

// MARK: - Validation Extension

private extension String {
    var isAlphaNumeric: Bool {
        range(of: "[^[:alnum:]]", options: .regularExpression) == nil
    }
}
