//
//  CreateTaskRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct CreateTaskRequest: ChatworkApiRequest {
    typealias Response = CreateTaskResponse

    enum LimitType: String, Encodable {
        case none
        case date
        case time
    }

    let roomId: Int
    let text: String
    let assigneeIds: [Int]
    let limitType: LimitType
    let deadline: Int?

    init(roomId: Int, text: String, assigneeIds: [Int], limitType: LimitType = .none, deadline: Int? = nil) {
        self.roomId = roomId
        self.text = text
        self.assigneeIds = assigneeIds
        self.limitType = limitType
        self.deadline = deadline
    }

    init(roomId: Int, text: String, assigneeIds: [Int], limitType: LimitType = .none, deadline: Date) {
        let deadlineInt = Int(deadline.timeIntervalSince1970)
        self.init(roomId: roomId,
                  text: text,
                  assigneeIds: assigneeIds,
                  limitType: limitType,
                  deadline: deadlineInt)
    }

    private enum CodingKeys: String, CodingKey {
        case text = "body"
        case assigneeIds = "to_ids"
        case limitType = "limit_type"
        case deadline = "limit"
    }

    var path: String { "rooms/\(roomId)/tasks" }
    var httpMethod: HTTPMethod = .post
}

struct CreateTaskResponse: ChatworkApiResponse {
    let taskIds: [Int]
}
