// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoderSchool working towards congrsional app challenge",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoderSchool working towards congrsional app challenge",
            targets: ["CoderSchool working towards congrsional app challenge"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoderSchool working towards congrsional app challenge"),
        .testTarget(
            name: "CoderSchool working towards congrsional app challengeTests",
            dependencies: ["CoderSchool working towards congrsional app challenge"]),
    ]
)
