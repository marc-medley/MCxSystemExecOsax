// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MCxSystemExecOsax",
    platforms: [
        // specify each minimum deployment requirement, 
        // otherwise the platform default minimum is used.
        .macOS(.v10_15), // .v10_14 Mojave, .v10_15 Catalina 
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MCxSystemExecOsax",
            type: .static,
            targets: ["MCxSystemExecOsax"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: <PACKAGE_URL>, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MCxSystemExecOsax",
            dependencies: []),
        .testTarget(
            name: "MCxSystemExecOsaxTests",
            dependencies: ["MCxSystemExecOsax"]),
    ],
    swiftLanguageVersions: [.v5] 
)
