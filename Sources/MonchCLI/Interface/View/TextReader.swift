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
        func read(with queryText: String) -> Output {
            print(queryText, terminator: "")
            let result: String
            do {
                result = try readString()
            } catch let error as ReadStringError {
                print(error.localizedDescription)
                return read(with: queryText)
            } catch {
                print(error.localizedDescription)
                fatalError("Unknown error!")
            }
            return completionHandler(result)
        }

        let queryText = "\n\(message): \n? "
        return read(with: queryText)
    }

    private func readString() throws -> String {
        guard let input = readLine() else { throw ReadStringError.readLineFailure }
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { throw ReadStringError.inputIsEmpty }
        return trimmed
    }
}

private enum ReadStringError: Error {
    case readLineFailure
    case inputIsEmpty

    var localizedDescription: String {
        switch self {
        case .readLineFailure:
            return "読み込みに失敗しました。"
        case .inputIsEmpty:
            return "入力が空です。もう一度入力してください。"
        }
    }
}
