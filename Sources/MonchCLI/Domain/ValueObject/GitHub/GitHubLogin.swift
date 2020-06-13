//
//  GitHubLogin.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

struct GitHubLogin: RawRepresentable, Equatable, Codable {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: - Domain Logic

    var isEmpty: Bool { rawValue.isEmpty }

    // MARK: - Codable

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
