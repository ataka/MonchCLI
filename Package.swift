// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MonchCLI",
    products: [
        .executable(name: "monch", targets: ["MonchCLI"])
    ],
    targets: [
        .target(
            name: "MonchCLI",
            dependencies: []),
        .testTarget(
            name: "MonchCLITests",
            dependencies: ["MonchCLI"]),
    ]
)

// Local Variables:
// swift-mode:parenthesized-expression-offset: 4
// End:
