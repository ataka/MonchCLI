//
//  TextReader.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/07/24.
//

import Foundation

struct TextReader<T> {
    typealias Output = T
    typealias CompletionHandler = (_ result: String) -> Output
    private let message: String
    private let completionHandler: CompletionHandler

    init(message: String, completionHandler: @escaping CompletionHandler) {
        self.message = message
        self.completionHandler = completionHandler
    }

    func read() -> Output {
        print("\n\(message): \n? ", terminator: "")
        guard let result = readLine() else { fatalError() }
        return completionHandler(result)
    }
}
