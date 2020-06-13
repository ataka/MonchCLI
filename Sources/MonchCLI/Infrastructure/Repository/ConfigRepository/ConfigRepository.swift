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
            let configFileObject = try ConfigFileObject.paths
                .lazy
                .filter { FileManager.default.fileExists(atPath: $0) }
                .map { try ConfigFileObjectFactory.make(path: $0) }
                .reduce(ConfigFileObject.empty) { $0.merging($1) }

            let config = Config(configFileObject: configFileObject)
            guard config.isValid() else { fatalError("BANG") }
            return config
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
