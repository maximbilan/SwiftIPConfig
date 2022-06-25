// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftIPConfig",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "SwiftIPConfig",
            targets: ["SwiftIPConfig"]),
    ],
    targets: [
        .target(
            name: "gateway",
            path: "Sources/gateway"),
        .target(
            name: "SwiftIPConfig",
            dependencies: ["gateway"],
            path: "Sources/SwiftIPConfig"),
        .testTarget(
            name: "SwiftIPConfigTests",
            dependencies: ["SwiftIPConfig"]),
    ]
)
