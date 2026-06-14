// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CallBlock",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "CallBlock",
            targets: ["CallBlock"]
        ),
        .library(
            name: "CallBlockDirectory",
            targets: ["CallBlockDirectory"]
        ),
    ],
    targets: [
        .target(
            name: "CallBlockShared"
        ),
        .target(
            name: "CallBlock",
            dependencies: ["CallBlockShared"],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "CallBlockDirectory",
            dependencies: ["CallBlockShared"]
        ),
    ]
)
