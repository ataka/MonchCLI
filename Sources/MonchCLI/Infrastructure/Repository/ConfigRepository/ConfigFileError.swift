//
//  ConfigFileError.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/20.
//

import Foundation

enum ConfigFileError: Error {
    case noProperty(name: String)

    var localizedDescription: String {
        switch self {
        case let .noProperty(name: propertyName):
            return """
            設定ファイル .monch.json で、次のプロパティーがセットされていないようです。
            設定ファイルを確認してください。

            設定されていないプロパティー: \(propertyName)
            """
        }
    }
}
