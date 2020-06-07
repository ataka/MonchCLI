//
//  GetAuthenticatedUserRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/07.
//

import Foundation

struct GetAuthenticatedUserRequest: GithubApiUnencodableRequest {
    typealias Response = GitHubUser

    var path = "user"
    var httpMethod: HTTPMethod = .get
}
