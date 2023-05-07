// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncExpectations",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "AsyncExpectations",
            targets: ["AsyncExpectations"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "AsyncExpectations",
            dependencies: [.product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")]),
        .testTarget(
            name: "AsyncExpectationsTests",
            dependencies: ["AsyncExpectations"]),
    ]
)
