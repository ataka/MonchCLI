//
//  CreateMessageRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct CreateMessageRequest: ChatworkApiRequest {
    typealias Response = CreateMessageResponse

    let roomId: Chatwork.RoomId
    let text: String
    private let selfUnread: Int = 0

    private enum CodingKeys: String, CodingKey {
        case text = "body"
        case selfUnread = "self_unread"
    }

    var path: String { "rooms/\(roomId.rawValue)/messages" }
    var httpMethod: HTTPMethod = .post
}

struct CreateMessageResponse: ChatworkApiResponse {
    let messageId: String
}
