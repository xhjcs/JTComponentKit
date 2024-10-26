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
            dependencies: [],
            path: "Sources/JTComponentKit",
            sources: ["**/*.m", "**/*.h"],
            publicHeadersPath: ".",
            privateHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".", .when(platforms: [.iOS]))
            ]
        )
    ]
)
