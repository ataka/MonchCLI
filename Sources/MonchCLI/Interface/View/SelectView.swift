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
        func getItem(from items: Items, with message: String) -> Item {
            print("\n> \(message): \n? ", terminator: "")

            let indexInt: Int
            do {
                indexInt = try readInt(for: items)
            } catch let error as ReadIntError {
                print(error.localizedDescription)
                return getItem(from: items, with: message)
            } catch {
                print(error.localizedDescription)
                fatalError("Unknown error!")
            }
            let index = AnyIndex(indexInt)

            return items[index]
        }

        print(makeListText(items: items, getTitle: getTitleHandler))
        return getItem(from: items, with: message)
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
        func getItems(from items: Items, with message: String) -> [Item] {
            print("\n> \(message): \n? ", terminator: "")

            let indexesInt: [Int]
            do {
                indexesInt = try readInts(for: items)
            } catch let error as ReadIntError {
                print(error.localizedDescription)
                return getItems(from: items, with: message)
            } catch {
                print(error.localizedDescription)
                fatalError("Unknown error!")
            }

            return indexesInt
                .map(AnyIndex.init)
                .map { items[$0] }
        }

        print(makeListText(items: items, getTitle: getTitleHandler))
        return getItems(from: items, with: message)
    }

    private func readInts(for items: Items) throws -> [Int] {
        guard let input = readLine() else { throw ReadIntError.readLineFailure }
        return try input.split(separator: ",")
            .map(String.init)
            .map({
                guard let index = Int($0) else { throw ReadIntError.notInteger }
                guard index >= 0          else { throw ReadIntError.negativeNumber }
                guard index < items.count else { throw ReadIntError.tooLargeNumber }
                return index
            })
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
