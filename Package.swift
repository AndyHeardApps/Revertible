// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Restorable",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "Restorable",
            targets: ["Restorable"]
        )
    ],
    targets: [
        .target(
            name: "Restorable",
            dependencies: []
        ),
        .testTarget(
            name: "RestorableTests",
            dependencies: ["Restorable"]
        )
    ]
)
