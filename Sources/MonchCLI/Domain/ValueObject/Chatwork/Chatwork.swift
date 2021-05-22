//
//  Chatwork.swift
//  
//
//  Created by 安宅正之 on 2021/05/23.
//

import Foundation

enum Chatwork {
    struct RoomId: Codable, Hashable, RawRepresentable {
        let rawValue: Int
    }
}
typealias ChatworkRoomId = Chatwork.RoomId
