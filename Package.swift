// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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

// Local Variables:
// swift-mode:parenthesized-expression-offset: 4
// End:
