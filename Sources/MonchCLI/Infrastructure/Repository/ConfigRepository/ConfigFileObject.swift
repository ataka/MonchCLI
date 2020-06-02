//
//  ConfigFileObject.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/03.
//

import Foundation

struct ConfigFileObject: Decodable {
    let chatwork: ChatworkFileObject?
    let github: GithubFileObject?
    let reviewers: [Config.Reviewer]?
}

struct ChatworkFileObject: Decodable {
    let token: String?
    let roomId: Int?
}

struct GithubFileObject: Decodable {
    let token: String?
    let repository: String?
}

extension Config {
    init(configFileObject obj: ConfigFileObject) {
        guard checkNil(obj) else { fatalError("BANG!") }
        self.init(
            chatwork: Chatwork(
                token: obj.chatwork!.token!,
                roomId: obj.chatwork!.roomId!
            ),
            github: Github(
                token: obj.github!.token!,
                repository: obj.github!.repository!
            ),
            reviewers: obj.reviewers!
        )
    }
}

private func checkNil<T>(_ x: T, labels: [String] = []) -> Bool {
    let mirror = Mirror(reflecting: x)
    guard let displayStyle = mirror.displayStyle else { return true }

    switch displayStyle {
    case .optional:
        guard let unwrappedValue = mirror.children.first?.value else { return false }
        return checkNil(unwrappedValue, labels: labels)
    case .collection:
        return !mirror.children.isEmpty
    default:
        return mirror.children.reduce(true) {
            let newLabels = labels + [ $1.label!]
            guard checkNil($1.value, labels: newLabels) else {
                let message = """
                設定ファイル .monch.json で、次のプロパティーがセットされていないようです。
                設定ファイルを確認してください。

                設定されていないプロパティー: (newLabels.joined(separator: ".")
                """
                fatalError(message)
            }
            return $0
        }
    }
}
