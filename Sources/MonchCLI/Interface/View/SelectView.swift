//
//  SelectView.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

struct SelectView<T> {
    typealias Item = T
    private let message: String
    private let items: [Item]
    private let getTitleHandler: (_ item: Item) -> String

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
        let itemList = items
            .enumerated()
            .map { (offset, item) in
                "[\(offset)] \(getTitleHandler(item))"
            }
            .joined(separator: "\n")
        print(itemList)

        print("\n> \(message): \n? ", terminator: "")
        guard let input = readLine(),
            let index = Int(input) else {
                fatalError()
        }

        return items[index]
    }
}
