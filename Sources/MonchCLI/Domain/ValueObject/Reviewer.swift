//
//  Reviewer.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

struct Reviewer: Hashable, Decodable {
    let name: String
    let chatworkId: Chatwork.ID
    let githubLogin: GitHubLogin
    let chatworkRoomId: Chatwork.RoomId?

    // MARK: - Domain Logic

    func validate() throws {
        guard !name.isEmpty        else { throw(ConfigFileError.reviewerNameEmpty) }
        guard !githubLogin.isEmpty else { throw(ConfigFileError.reviewerGitHubLoginEmpty) }
        return
    }

    typealias FilterClosure = (_ reviewer: Self) -> Bool

    static func isReviewable(with pullRequest: PullRequest) -> FilterClosure {
        return {
            $0.githubLogin != pullRequest.user.login
        }
    }
}
