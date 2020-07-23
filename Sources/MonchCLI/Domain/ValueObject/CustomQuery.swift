//
//  CustomQuery.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/07/24.
//

import Foundation

struct CustomQuery: Decodable {
    struct Answer: RawRepresentable {
        var rawValue: String

        init?(rawValue: String) { fatalError("Use .init(format:result:)") }
        init(format: String, result: String) {
            rawValue = String(format: format, result)
        }
    }

    let message: String
    let format: String

    // MARK: Domain Logic

    func getAnswer(with result: String) -> Answer {
        Answer(format: format, result: result)
    }
}
