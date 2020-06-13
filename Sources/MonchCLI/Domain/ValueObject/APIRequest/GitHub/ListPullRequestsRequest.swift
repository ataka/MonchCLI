//
//  ListPullRequestsRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct ListPullRequestsRequest: GithubApiRequest {
    typealias Response = Array<PullRequest>

    let repository: String
    let state: PullRequest.State

    init(repository: String, state: PullRequest.State) {
        self.repository = repository
        self.state = state
    }

    init(config: Config.Github, state: PullRequest.State = .open) {
        self.init(
            repository: config.repository,
            state: state
        )
    }

    private enum CodingKeys: String, CodingKey {
        case state
    }

    var path: String { "repos/\(repository)/pulls" }
    var httpMethod: HTTPMethod = .get
}

extension Array: ApiResponse where Element == PullRequest {}
