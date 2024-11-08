// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Revertible",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11),
        .tvOS(.v18),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Revertible",
            targets: ["Revertible"]
        )
    ],
    targets: [
        .target(
            name: "Revertible",
            dependencies: [],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "RevertibleTests",
            dependencies: ["Revertible"],
            swiftSettings: swiftSettings
        )
    ],
    swiftLanguageModes: [.v6]
)

var swiftSettings: [SwiftSetting] { [
    .enableExperimentalFeature("StrictConcurrency"),
] }
