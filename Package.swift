// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
        ),
        .executable(
            name: "Client",
            targets: ["Client"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0")
    ],
    targets: [
        .macro(
            name: "RevertibleMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Revertible",
            dependencies: ["RevertibleMacros"],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "Client",
            dependencies: ["Revertible"]
        ),
        .testTarget(
            name: "RevertibleTests",
            dependencies: [
                "Revertible",
                "RevertibleMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ],
            swiftSettings: swiftSettings
        )
    ],
    swiftLanguageModes: [.v6]
)

var swiftSettings: [SwiftSetting] { [
    .enableExperimentalFeature("StrictConcurrency"),
] }
