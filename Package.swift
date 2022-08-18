// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "YrsC",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_10),
    ],
    products: [
        .library(name: "YrsC", targets: ["YrsC"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "YrsC",
            url: "https://github.com/heckj/YrsC/releases/download/0.11.2-alpha1/YrsC.xcframework.zip",
            checksum: "6ce0f000c6f177589a2a889b1db61e90ae194f1d528fdb8bd0389034d1236a6d"
        )
    ]
)
