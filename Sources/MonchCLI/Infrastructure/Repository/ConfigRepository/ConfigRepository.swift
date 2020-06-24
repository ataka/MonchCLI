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
                .filter(FileManager.default.fileExists(atPath:))
                .map { try ConfigFileObjectFactory.make(path: $0) }
                .reduce(ConfigFileObject.empty) { $0.merging($1) }

            let config = try Config(configFileObject: configFileObject)
            try config.validate()
            return config
        } catch let error as ConfigFileError {
            print(error.localizedDescription)
            exit(.invalidConfigFile)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
