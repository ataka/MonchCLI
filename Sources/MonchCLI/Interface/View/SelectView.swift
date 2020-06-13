//
//  SelectView.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

struct SelectView<T> {
    typealias Item = T
    typealias GetTitleHandler = (_ item: Item) -> String
    private let message: String
    private let items: [Item]
    private let getTitleHandler: GetTitleHandler

    init(message: String, items: [Item], getTitleHandler: @escaping (_ item: Item) -> String) {
        self.message = message
        self.items = items
        self.getTitleHandler = getTitleHandler
    }

    init(message: String, items: ArraySlice<Item>, getTitleHandler: @escaping (_ item: Item) -> String) {
        self.init(message: message,
                  items: Array(items),
                  getTitleHandler: getTitleHandler)
    }

    func getItem() -> Item {
        print(makeListText(items: items, getTitle: getTitleHandler))
        print("\n> \(message): \n? ", terminator: "")
        guard let input = readLine(),
            let index = Int(input) else {
                fatalError()
        }

        return items[index]
    }

    private func makeListText(items: [Item], getTitle: GetTitleHandler) -> String {
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
            .compactMap { Int($0) }
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
