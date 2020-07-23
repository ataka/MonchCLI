//
//  PullRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct PullRequest: ApiResponse {
    enum State: String, Encodable {
        case open
        case closed
        case all
    }

    let id: Int
    let htmlUrl: String
    let title: String
    let number: Int
    let user: GitHubUser
    let requestedReviewers: [GitHubUser]

    // MARK: - Domain Logic

    typealias FilterClosure = (_ pullRequest: Self) -> Bool

    static func isListable(showsAll: Bool, authenticatedUser: GitHubUser) -> FilterClosure {
        if showsAll {
            return { _ in true }
        } else {
            return { $0.user == authenticatedUser }
        }
    }
}
