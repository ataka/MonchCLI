//
//  CreateReviewRequestRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/01.
//

import Foundation

typealias GitHubUser = String

struct CreateReviewRequestRequest: GithubApiRequest {
    typealias Response = PullRequest

    let pullRequestId: Int
    let reviewers: [GitHubUser]

    private enum CodingKeys: String, CodingKey {
        case reviewers
    }

    var path: String { "pulls/\(pullRequestId)/requested_reviewers" }
}
