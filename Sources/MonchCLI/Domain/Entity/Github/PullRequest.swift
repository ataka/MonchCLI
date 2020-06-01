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
}
