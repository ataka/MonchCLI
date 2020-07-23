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

    func validate() throws {
        guard !message.isEmpty                else { throw(ConfigFileError.customQueryMessageEmpty) }
        guard !format.isEmpty                 else { throw(ConfigFileError.customQueryFormatEmpty) }
        guard format.occurrence(of: "%@") < 2 else { throw(ConfigFileError.customQueryFormatTooManyAtMark) }
        return
    }

    func getAnswer(with result: String) -> Answer {
        Answer(format: format, result: result)
    }
}

private extension String {
    func occurrence(of substr: String) -> Int {
        { $0.isEmpty ? 0 : $0.count - 1 }(self.components(separatedBy: substr))
    }
}
