// swift-tools-version: 6.2
// Package manifest for the MrHammadClaw macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "MrHammadClaw",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "MrHammadClawIPC", targets: ["MrHammadClawIPC"]),
        .library(name: "MrHammadClawDiscovery", targets: ["MrHammadClawDiscovery"]),
        .executable(name: "MrHammadClaw", targets: ["MrHammadClaw"]),
        .executable(name: "mrhammadclaw-mac", targets: ["MrHammadClawMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/MrHammadClawKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "MrHammadClawIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "MrHammadClawDiscovery",
            dependencies: [
                .product(name: "MrHammadClawKit", package: "MrHammadClawKit"),
            ],
            path: "Sources/MrHammadClawDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "MrHammadClaw",
            dependencies: [
                "MrHammadClawIPC",
                "MrHammadClawDiscovery",
                .product(name: "MrHammadClawKit", package: "MrHammadClawKit"),
                .product(name: "MrHammadClawChatUI", package: "MrHammadClawKit"),
                .product(name: "MrHammadClawProtocol", package: "MrHammadClawKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/MrHammadClaw.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "MrHammadClawMacCLI",
            dependencies: [
                "MrHammadClawDiscovery",
                .product(name: "MrHammadClawKit", package: "MrHammadClawKit"),
                .product(name: "MrHammadClawProtocol", package: "MrHammadClawKit"),
            ],
            path: "Sources/MrHammadClawMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "MrHammadClawIPCTests",
            dependencies: [
                "MrHammadClawIPC",
                "MrHammadClaw",
                "MrHammadClawDiscovery",
                .product(name: "MrHammadClawProtocol", package: "MrHammadClawKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
