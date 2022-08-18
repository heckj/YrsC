// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "YCRDTC",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_10),
    ],
    products: [
        .library(name: "Y-CRDT-C", targets: ["Y-CRDT-C"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "Y-CRDT-C",
            url: "https://github.com/heckj/Y-CRDT-C/releases/download/0.11.2/Y-CRDT-C.xcframework.zip",
            checksum: "27694825d227b466cecc0b54aead8d90529f722b0938dd6ac176670c6a1606a3"
        )
    ]
)
