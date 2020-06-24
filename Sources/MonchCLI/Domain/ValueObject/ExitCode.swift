//
//  ExitCode.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/20.
//

import Foundation

enum ExitCode: Int32, Error {
    case success
    case invalidConfigFile
}

func exit(_ exitCode: ExitCode) -> Never {
    switch exitCode {
    case .success: exit(EXIT_SUCCESS)
    default:
        exit(exitCode.rawValue)
    }
}
