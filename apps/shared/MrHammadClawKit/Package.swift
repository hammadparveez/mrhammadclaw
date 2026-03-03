// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MrHammadClawKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "MrHammadClawProtocol", targets: ["MrHammadClawProtocol"]),
        .library(name: "MrHammadClawKit", targets: ["MrHammadClawKit"]),
        .library(name: "MrHammadClawChatUI", targets: ["MrHammadClawChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "MrHammadClawProtocol",
            path: "Sources/MrHammadClawProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "MrHammadClawKit",
            dependencies: [
                "MrHammadClawProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/MrHammadClawKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "MrHammadClawChatUI",
            dependencies: [
                "MrHammadClawKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/MrHammadClawChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "MrHammadClawKitTests",
            dependencies: ["MrHammadClawKit", "MrHammadClawChatUI"],
            path: "Tests/MrHammadClawKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
