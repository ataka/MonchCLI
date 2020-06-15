//
//  SelectView.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

struct SelectView<T> {
    typealias Item = T
    typealias Items = AnyCollection<Item>
    typealias GetTitleHandler = (_ item: Item) -> String
    private let message: String
    private let items: Items
    private let getTitleHandler: GetTitleHandler

    init<C>(message: String, items: C, getTitleHandler: @escaping (_ item: Item) -> String) where C: Collection, C.Element == Item {
        self.message = message
        self.items = AnyCollection<Item>(items)
        self.getTitleHandler = getTitleHandler
    }

    func getItem() -> Item {
        print(makeListText(items: items, getTitle: getTitleHandler))
        print("\n> \(message): \n? ", terminator: "")
        var indexInt: Int
        do {
            indexInt = try readInt(for: items)
        } catch {
            print(error.localizedDescription)
            return getItem()
        }
        let index = AnyIndex(indexInt)

        return items[index]
    }

    private func makeListText(items: Items, getTitle: GetTitleHandler) -> String {
        return items
            .enumerated()
            .map({ (offset, item) in
                "[\(offset)] \(getTitle(item))"
            })
            .joined(separator: "\n")
    }

    private func readInt(for items: Items) throws -> Int {
        guard let input = readLine() else { throw ReadIntError.readLineFailure }
        guard let index = Int(input) else { throw ReadIntError.notInteger }
        guard index >= 0             else { throw ReadIntError.negativeNumber }
        guard index < items.count    else { throw ReadIntError.tooLargeNumber }
        return index
    }

    func getItems() -> [Item] {
        print(makeListText(items: items, getTitle: getTitleHandler))
        print("\n> \(message): \n? ", terminator: "")
        guard let input = readLine() else { fatalError() }

        return input.split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
            .map(AnyIndex.init)
            .map { items[$0] }
    }
}

enum ReadIntError: Error {
    case readLineFailure
    case notInteger
    case negativeNumber
    case tooLargeNumber

    var localizedDescription: String {
        switch self {
        case .readLineFailure:
            return "読み込みに失敗しました。"
        case .notInteger:
            return "数字を入力してください。"
        case .negativeNumber:
            return "マイナス値が入力されたようです。ゼロ以上の数を入力してください。"
        case .tooLargeNumber:
            return "数が大きすぎるようです。リスト番号を入力してください。"
        }
    }
}
