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

    func isValid() -> Bool {
        chatwork.isValid()
            && github.isValid()
            && reviewers.reduce(true) { $0 && $1.isValid() }
    }
}

extension Config {
    struct Chatwork {
        let token: String
        let roomId: Int

        func isValid() -> Bool {
            guard !token.isEmpty else {
                fatalError("Chatwork Token が空です。設定ファイルを確認してください。")
            }
            guard token.isAlphaNumeric else {
                fatalError("Chatwork Token はアルファベットと数字の組み合わせです。設定ファイルを確認してください。")
            }
            return true
        }
    }
}

extension Config {
    struct Github {
        let token: String
        let repository: String

        func isValid() -> Bool {
            guard !token.isEmpty else {
                fatalError("GitHub Token が空です。設定ファイルを確認してください。")
            }
            guard token.isAlphaNumeric else {
                fatalError("GitHub Token はアルファベットと数字の組み合わせです。設定ファイルを確認してください。")
            }
            return true
        }
    }
}

// MARK: - Validation Extension

private extension String {
    var isAlphaNumeric: Bool {
        range(of: "[^[:alnum:]]", options: .regularExpression) == nil
    }
}
