//
//  Reviewer.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

struct Reviewer: Decodable {
    let name: String
    let chatworkId: Int
    let githubLogin: GitHubLogin

    // MARK: - Domain Logic

    func isValid() -> Bool {
        guard !name.isEmpty else {
            fatalError("Reviewer の名前が空です。設定ファイルを確認してください。")
        }
        guard !githubLogin.isEmpty else {
            fatalError("Reviewer の GitHub の名前が空です。設定ファイルを確認してください。")
        }
        return true
    }

    typealias FilterClosure = (_ reviewer: Self) -> Bool

    static func isReviewable(with pullRequest: PullRequest) -> FilterClosure {
        return {
            $0.githubLogin != pullRequest.user.login
        }
    }
}
