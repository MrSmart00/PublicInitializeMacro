// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "packages",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(
            name: "packages",
            targets: ["App"]),
    ],
    targets: [
        .target(
            name: "App"),
    ]
)
