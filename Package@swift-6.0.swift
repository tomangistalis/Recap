// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Recap",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16), .macCatalyst(.v16), .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Recap",
            targets: ["Recap"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Recap",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "RecapTests",
            dependencies: ["Recap"]
        )
    ]
)
