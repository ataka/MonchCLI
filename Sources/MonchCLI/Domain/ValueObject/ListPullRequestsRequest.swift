//
//  ListPullRequestsRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct ListPullRequestsRequest: GithubApiRequest {
    typealias Response = Array<PullRequest>

    let state: PullRequest.State

    init(state: PullRequest.State = .open) {
        self.state = state
    }

    private enum CodingKeys: String, CodingKey {
        case state
    }

    var path = "pulls"
}

extension Array: ApiResponse where Element == PullRequest {}
