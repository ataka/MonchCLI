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
        guard let input = readLine(),
            let indexInt = Int(input) else {
            fatalError()
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

    func getIndex() -> Int {
        print(makeListText(items: items, getTitle: getTitleHandler))
        print("\n> \(message): \n? ", terminator: "")
        guard let input = readLine(),
            let index = Int(input) else {
                fatalError()
        }

        return index
    }
}
