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
            url: "https://github.com/heckj/YrsC/releases/download/0.15/YrsC.xcframework.zip",
            checksum: "67dcc48e87da7e49ac1d7362adda5acb2607f8f20d93f7b4de35134f2adb5980"
        )
    ]
)
