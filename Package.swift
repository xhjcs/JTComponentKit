// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JTComponentKit",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "JTComponentKit", targets: ["JTComponentKit"]),
    ],
    targets: [
        .target(
            name: "JTComponentKit",
            path: "Sources/JTComponentKit"
        )
    ]
)
