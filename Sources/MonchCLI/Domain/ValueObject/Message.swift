//
//  Message.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/30.
//

import Foundation

struct Message: Encodable {
    let roomId: Int
    let text: String
    private let selfUnread: Int = 0

    private enum CodingKeys: String, CodingKey {
        case text = "body"
        case selfUnread = "self_unread"
    }
}

struct CreateMessageResponse: Decodable {
    let messageId: String
}
