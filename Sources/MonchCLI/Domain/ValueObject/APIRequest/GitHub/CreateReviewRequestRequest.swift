//
//  CreateReviewRequestRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/01.
//

import Foundation

struct CreateReviewRequestRequest: GithubApiRequest {
    typealias Response = PullRequest
    typealias GitHubUser = String

    let repository: String
    let pullRequestId: Int
    let reviewers: [GitHubUser]

    private enum CodingKeys: String, CodingKey {
        case reviewers
    }

    var path: String { "repos/\(repository)/pulls/\(pullRequestId)/requested_reviewers" }
    var httpMethod: HTTPMethod = .post
}