//
//  ConfigFileError.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/20.
//

import Foundation

enum ConfigFileError: Error {
    case noProperty(name: String)
    // MARK: Chatwork
    case chatworkTokenEmpty
    case chatworkTokenWrongCharacter
    // MARK: GitHub
    case gitHubTokenEmpty
    case gitHubTokenWrongCharacter
    // MARK: Reviewer
    case reviewerNameEmpty
    case reviewerGitHubLoginEmpty

    // MARK: - Localized Description

    var localizedDescription: String {
        switch self {
        case let .noProperty(name: propertyName):
            return """
            設定ファイル .monch.json で、次のプロパティーがセットされていないようです。
            設定ファイルを確認してください。

            設定されていないプロパティー: \(propertyName)
            """
        case .chatworkTokenEmpty:
            return "Chatwork Token が空です。設定ファイルを確認してください。"
        case .chatworkTokenWrongCharacter:
            return "Chatwork Token はアルファベットと数字の組み合わせです。設定ファイルを確認してください。"
        case .gitHubTokenEmpty:
            return "GitHub Token が空です。設定ファイルを確認してください。"
        case .gitHubTokenWrongCharacter:
            return "GitHub Token はアルファベットと数字の組み合わせです。設定ファイルを確認してください。"
        case .reviewerNameEmpty:
            return "Reviewer の名前が空です。設定ファイルを確認してください。"
        case .reviewerGitHubLoginEmpty:
            return "Reviewer の GitHub の名前が空です。設定ファイルを確認してください。"
        }
    }
}
