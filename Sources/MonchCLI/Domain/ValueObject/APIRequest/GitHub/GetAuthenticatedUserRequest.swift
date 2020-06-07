//
//  GetAuthenticatedUserRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/07.
//

import Foundation

struct GetAuthenticatedUserRequest: GithubApiRequest, Unencodable {
    typealias Response = GitHubUser
    let unencodable = true

    private enum CodingKeys: CodingKey {
        case unencodable
    }

    var path = "user"
    var httpMethod: HTTPMethod = .get
}
