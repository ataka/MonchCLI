//
//  GitHubAuthUserRepository.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/07.
//

import Foundation

struct GitHubAuthUserRepository {
    private struct Version {
        static let number: Int = 1
        static let key = "GitHubAuthUser.Version"
    }
    private let key = "GitHubAuthUser"

    func fetch() -> GitHubUser? {
        guard UserDefaults.standard.integer(forKey: key) == Version.number,
            let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(GitHubUser.self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func save(_ authUser: GitHubUser) {
        do {
            let data = try JSONEncoder().encode(authUser)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.set(Version.number, forKey: Version.key)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func delete() {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.removeObject(forKey: Version.key)
    }
}
