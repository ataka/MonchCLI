//
//  ConfigFileObject.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/03.
//

import Foundation

struct ConfigFileObject: Decodable {
    private static let systemFileName = "monch.json"
    private static let fileName = ".monch.json"

    let chatwork: ChatworkFileObject?
    let github: GithubFileObject?
    let reviewers: [Config.Reviewer]?

    // MARK: Path

    static var paths: [String] {
        [
            systemDirPath,
            homeDirPath,
            currentDirPath,
        ].compactMap { $0 }
    }

    private static let systemDirPath = "/etc/\(systemFileName)"

    private static var homeDirPath: String? {
        guard let homeDir = ProcessInfo.processInfo.environment["HOME"] else { return nil }
        return "\(homeDir)/\(fileName)"
    }

    private static var currentDirPath: String {
        #if DEBUG
        return URL(fileURLWithPath: Main.filePath)
                .pathComponents
                .dropLast(3)
                .joined(separator: "/") + "/\(fileName)"
        #else
        return FileManager.default.currentDirectoryPath + "/\(fileName)"
        #endif
    }

    // MARK: Merge

    static var empty: Self {
        ConfigFileObject(
            chatwork: nil,
            github: nil,
            reviewers: []
        )
    }

    func merging(_ other: Self) -> Self {
        ConfigFileObject(
            chatwork: chatwork?.merging(other.chatwork) ?? other.chatwork,
            github: github?.merging(other.github) ?? other.github,
            reviewers: [reviewers, other.reviewers].compactMap { $0 }.flatMap { $0 }
        )
    }
}

struct ChatworkFileObject: Decodable {
    let token: String?
    let roomId: Int?

    func merging(_ other: Self?) -> Self {
        ChatworkFileObject(
            token: other?.token ?? token,
            roomId: other?.roomId ?? roomId
        )
    }
}

struct GithubFileObject: Decodable {
    let token: String?
    let repository: String?

    func merging(_ other: Self?) -> Self {
        GithubFileObject(
            token: other?.token ?? token,
            repository: other?.repository ?? repository
        )
    }
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
