//
//  ConfigRepository.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/03.
//

import Foundation

struct ConfigRepository {
    func fetch() -> Config {
        do {
            let fileName = ".monch.json"
            #if DEBUG
            let pathString: String = { (path: String) in
                URL(fileURLWithPath: path)
                    .pathComponents
                    .dropLast(3)
                    .joined(separator: "/") + "/\(fileName)"
            }(Main.filePath)
            #else
            let pathString = FileManager.default.currentDirectoryPath + "/\(fileName)"
            #endif
            let pathUrl = URL(fileURLWithPath: pathString)

            let data = try Data(contentsOf: pathUrl)
            let configFileObject = try JSONDecoder().decode(ConfigFileObject.self, from: data)
            return Config(configFileObject: configFileObject)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
