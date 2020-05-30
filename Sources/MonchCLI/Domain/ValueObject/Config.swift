//
//  Config.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/30.
//

import Foundation

struct Config: Decodable {
    let chatworkToken: String
    let roomId: Int
}
