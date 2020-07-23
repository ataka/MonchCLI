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
    let reviewers: [Reviewer]?
    let customQueries: [CustomQuery]?

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
        return URL(fileURLWithPath: Monch.filePath)
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
            reviewers: [],
            customQueries: []
        )
    }

    func merging(_ other: Self) -> Self {
        ConfigFileObject(
            chatwork: chatwork?.merging(other.chatwork) ?? other.chatwork,
            github: github?.merging(other.github) ?? other.github,
            reviewers: (reviewers ?? []).merging(other.reviewers),
            customQueries: (customQueries ?? []) + (other.customQueries ?? [])
        )
    }
}

private extension Array where Element == Reviewer {
    func merging(_ others: [Reviewer]?) -> [Reviewer] {
        guard let others = others else { return self }
        let sets = Set(self)
        return others.reduce(into: self) {
            guard !sets.contains($1) else { return }
            $0.append($1)
        }
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
    init(configFileObject obj: ConfigFileObject) throws {
        try checkNil(obj)
        self.init(
            chatwork: Chatwork(
                token: obj.chatwork!.token!,
                roomId: obj.chatwork!.roomId!
            ),
            github: Github(
                token: obj.github!.token!,
                repository: obj.github!.repository!
            ),
            reviewers: obj.reviewers!,
            customQueries: obj.customQueries!
        )
    }
}

private func checkNil<T>(_ x: T) throws {
    func checkNil<T>(_ x: T, labels: [String]) throws -> Bool {
        let mirror = Mirror(reflecting: x)
        guard let displayStyle = mirror.displayStyle else { return true }

        switch displayStyle {
        case .optional:
            guard let unwrappedValue = mirror.children.first?.value else { return false }
            return try checkNil(unwrappedValue, labels: labels)
        case .collection:
            return !mirror.children.isEmpty
        default:
            return try mirror.children.reduce(true) {
                let newLabels = labels + [$1.label!]
                guard try checkNil($1.value, labels: newLabels) else {
                    throw(ConfigFileError.noProperty(name: newLabels.joined(separator: ".")))
                }
                return $0
            }
        }
    }

    _ = try checkNil(x, labels: [])
}
