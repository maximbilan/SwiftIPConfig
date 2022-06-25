// swift-tools-version: 5.6
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
            path: "Sources/SwiftIPConfig")
    ]
)
