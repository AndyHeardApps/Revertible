// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Revertable",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "Revertable",
            targets: ["Revertable"]
        )
    ],
    targets: [
        .target(
            name: "Revertable",
            dependencies: []
        ),
        .testTarget(
            name: "RevertableTests",
            dependencies: ["Revertable"]
        )
    ]
)
