// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MonchCLI",
    products: [
        .executable(name: "monch", targets: ["MonchCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.0"),
    ],
    targets: [
        .target(
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
