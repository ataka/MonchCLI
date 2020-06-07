//
//  GitHubAuthUserRepository.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/07.
//

import Foundation

struct GitHubAuthUserRepository {
    private let key = "GitHubAuthUser"

    func fetch() -> GitHubUser? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
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
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func delete() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
