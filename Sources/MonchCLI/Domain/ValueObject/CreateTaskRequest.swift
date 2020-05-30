//
//  CreateTaskRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct CreateTaskRequest: ChatworkApiRequest {
    typealias ApiResponse = CreateTaskResponse

    enum LimitType: String, Encodable {
        case none
        case date
        case time
    }

    let roomId: Int
    let text: String
    let limitType: LimitType
    let assigneeIds: [Int]

    private enum CodingKeys: String, CodingKey {
        case text = "body"
        case limitType = "limit_type"
        case assigneeIds = "to_ids"
    }

    var path: String { "rooms/\(roomId)/tasks" }
}

struct CreateTaskResponse: Decodable {
    let taskIds: [Int]
}
