// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "MonchCLI",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "monch", targets: ["MonchCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "MonchCLI",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "MonchCLITests",
            dependencies: ["MonchCLI"]),
    ]
)

// https://blog.eidinger.info/develop-a-command-line-tool-using-swift-concurrency
// IMPORTANT: enable the following function call if you encounter the error
//    `dyld: Library not loaded: @rpath/libswift_Concurrency.dylib`

hookInternalSwiftConcurrency()

func hookInternalSwiftConcurrency() {
    let isFromTerminal = ProcessInfo.processInfo.environment.values.contains("/usr/bin/swift")
    if !isFromTerminal {
        package.targets.first?.addLinkerSettingUnsafeFlagRunpathSearchPath()
    }
}

extension PackageDescription.Target {
    func addLinkerSettingUnsafeFlagRunpathSearchPath() {
        linkerSettings = [linkerSetting]
    }

    private var linkerSetting: LinkerSetting {
        guard let xcodeFolder = Executable("/usr/bin/xcode-select")("-p") else {
            fatalError("Could not run `xcode-select -p`")
        }

        let toolchainFolder = "\(xcodeFolder.trimmed)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift-5.5/macosx"

        return .unsafeFlags(["-rpath", toolchainFolder])
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
}

private struct Executable {
    private let url: URL

    init(_ filePath: String) {
        url = URL(fileURLWithPath: filePath)
    }

    func callAsFunction(_ arguments: String...) -> String? {
        let process = Process()
        process.executableURL = url
        process.arguments = arguments

        let stdout = Pipe()
        process.standardOutput = stdout

        process.launch()
        process.waitUntilExit()

        return stdout.readStringToEndOfFile()
    }
}

extension Pipe {
    func readStringToEndOfFile() -> String? {
        let data: Data
        if #available(OSX 10.15.4, *) {
            data = (try? fileHandleForReading.readToEnd()) ?? Data()
        } else {
            data = fileHandleForReading.readDataToEndOfFile()
        }

        return String(data: data, encoding: .utf8)
    }
}

// Local Variables:
// swift-mode:parenthesized-expression-offset: 4
// End:
