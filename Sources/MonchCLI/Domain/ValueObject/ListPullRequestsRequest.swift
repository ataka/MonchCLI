//
//  ListPullRequestsRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct ListPullRequestsRequest: GithubApiRequest {
    typealias ApiResponse = Array<PullRequest>

    let state: String = "open"

    private enum CodingKeys: String, CodingKey {
        case state
    }

    var path = "pulls"
}

struct PullRequest: Decodable {
    let id: Int
    let url: String
    let title: String
}
