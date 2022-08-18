// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "YCRDTC",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_10),
    ],
    products: [
        .library(name: "YCRDTC", targets: ["YCRDTC"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "YCRDTC",
            url: "https://github.com/heckj/Y-CRDT-C/releases/download/0.11.5/YCRDTC.xcframework.zip",
            checksum: "9cc323bcab678ec50b5391cce4fd3dc2a750e79d720e7fd5a09b1e892b7592c7"
        )
    ]
)
