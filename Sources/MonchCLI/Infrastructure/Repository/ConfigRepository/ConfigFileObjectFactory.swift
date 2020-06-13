//
//  ConfigFileObjectFactory.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/07.
//

import Foundation

struct ConfigFileObjectFactory {
    static func make(path: String) throws -> ConfigFileObject {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(ConfigFileObject.self, from: data)
    }
}
