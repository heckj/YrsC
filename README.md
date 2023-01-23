# Swift package wrapping Y CRDT's FFI C-based interface

Much of the setup here is inspired by the blog post about building
C FFI interfaces from Rust and combining them to make them available
for Swift on various Apple platforms.

https://betterprogramming.pub/from-rust-to-swift-df9bde59b7cd

## Building the C interface (macOS)

    rustup update
    echo "x86_64-apple-ios-macabi and aarch64-apple-ios-macabi require the nightly toolchain"
    rustup toolchain install nightly

    ### to allow for abi builds from the nightly toolchain for xargo...
    rustup component add rust-src
    echo "▸ Install xargo"
    cargo install xargo

    rustup target add x86_64-apple-ios
    rustup target add aarch64-apple-ios
    rustup target add aarch64-apple-darwin # ARM macOS
    rustup target add x86_64-apple-darwin  # x86 macOS
    rustup target add aarch64-apple-ios-sim
    rustup target add aarch64-apple-ios-macabi # MacCatalyst
    rustup target add x86_64-apple-ios-macabi # MacCatalyst

    git clone https://github.com/y-crdt/y-crdt.git
    pushd y-crdt
    git checkout v0.11.2
    rm -rf target
    #cargo update

    echo "▸ Build x86_64-apple-ios"
    cargo build --target x86_64-apple-ios --package yffi --release

    echo "▸ Build aarch64-apple-ios-sim"
    xargo build -Zbuild-std --target aarch64-apple-ios-sim --package yffi --release

    echo "▸ Build aarch64-apple-ios"
    cargo build --target aarch64-apple-ios --package yffi --release

    echo "▸ Build aarch64-apple-darwin"
    cargo build --target aarch64-apple-darwin --package yffi --release

    echo "▸ Build x86_64-apple-darwin"
    cargo build --target x86_64-apple-darwin --package yffi --release

    echo "▸ x86_64-apple-ios-macabi"
    xargo build -Zbuild-std --target x86_64-apple-ios-macabi --package yffi --release

    echo "▸ aarch64-apple-ios-macabi"
    xargo build -Zbuild-std --target aarch64-apple-ios-macabi --package yffi --release

    popd

C target results at:

```bash
# header
y-crdt/tests-ffi/include/libyrs.h
# macOS architectures
y-crdt/target/x86_64-apple-darwin/release/libyrs.a
y-crdt/target/aarch64-apple-darwin/release/libyrs.a
# iOS architectures
y-crdt/target/x86_64-apple-ios/release/libyrs.a
y-crdt/target/aarch64-apple-ios/release/libyrs.a
# Simulators
y-crdt/target/aarch64-apple-ios-sim/release/libyrs.a
# MacCatalyst
y-crdt/target/x86_64-apple-ios-macabi/release/libyrs.a
y-crdt/target/aarch64-apple-ios-macabi/release/libyrs.a
```

Use additional `lipo` commands (per blog post examples) to combine the resulting static libraries into a single fat file library for each target.

    echo "▸ Lipo macOS"
    mkdir -p ./y-crdt/target/apple-darwin/release
    lipo -create  \
        ./y-crdt/target/x86_64-apple-darwin/release/libyrs.a \
        ./y-crdt/target/aarch64-apple-darwin/release/libyrs.a \
        -output ./y-crdt/target/apple-darwin/release/libyrs.a

    echo "▸ Lipo simulator"
    mkdir -p ./y-crdt/target/apple-ios-simulator/release
    lipo -create  \
        ./y-crdt/target/x86_64-apple-ios/release/libyrs.a \
        ./y-crdt/target/aarch64-apple-ios-sim/release/libyrs.a \
        -output ./y-crdt/target/apple-ios-simulator/release/libyrs.a

    echo "▸ Lipo ios-macabi (MacCatalyst)"
    mkdir -p ./y-crdt/target/apple-ios-macabi/release
    lipo -create  \
        ./y-crdt/target/aarch64-apple-ios-macabi/release/libyrs.a \
        ./y-crdt/target/x86_64-apple-ios-macabi/release/libyrs.a \
        -output ./y-crdt/target/apple-ios-macabi/release/libyrs.a

Architecture of the library:

    lipo -info ./y-crdt/target/apple-darwin/release/libyrs.a
`Architectures in the fat file: target/apple-darwin/release/libyrs.a are: x86_64 arm64`

Copy the header into the top level include directory so that swift can
use it:

    # copy the header for the XCFramework
    cp ./y-crdt/tests-ffi/include/libyrs.h ./include/

Generate an XCFramework:

    rm -rf xcframework
    mkdir -p xcframework

    xcodebuild -create-xcframework \
        -library ./y-crdt/target/apple-ios-simulator/release/libyrs.a \
        -headers ./include \
        -library ./y-crdt/target/aarch64-apple-ios/release/libyrs.a \
        -headers ./include \
        -library ./y-crdt/target/apple-ios-macabi/release/libyrs.a \
        -headers ./include \
        -library ./y-crdt/target/apple-darwin/release/libyrs.a \
        -headers ./include \
        -output ./xcframework/YrsC.xcframework

    echo "▸ Compress YrsC.xcframework"
    ditto -c -k --sequesterRsrc --keepParent ./xcframework/YrsC.xcframework ./YrsC.xcframework.zip

    echo "▸ Compute YrsC.xcframework checksum"
    swift package compute-checksum ./YrsC.xcframework.zip

`6ce0f000c6f177589a2a889b1db61e90ae194f1d528fdb8bd0389034d1236a6d`

- update Package.swift with the checksum and updated tag
  - make sure the tag follows a x.y.z semantic version format!
- commit the changes and push them up to Github
- Create a new release through Github's web interface: https://github.com/heckj/YrsC/releases/new
  - drag `YrsC.xcframework.zip` into the binaries
  - update the tag to the next iteration
  - add any relevant notes
  - publish
