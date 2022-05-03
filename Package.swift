// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let remoteDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    .package(url: "https://github.com/arman095095/Managers.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Module.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/DesignSystem.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/AlertManager.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Utils.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Account.git", branch: "develop")
]

private let localDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Managers"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Module"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/DesignSystem"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/AlertManager"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Utils"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Account")
]

let isDev = false
private let dependencies = isDev ? localDependencies : remoteDependencies

let package = Package(
    name: "Authorization",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Authorization",
            targets: ["Authorization"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "Authorization",
            dependencies: [.product(name: "Module", package: "Module"),
                           .product(name: "Managers", package: "Managers"),
                           .product(name: "DesignSystem", package: "DesignSystem"),
                           .product(name: "AlertManager", package: "AlertManager"),
                           .product(name: "Utils", package: "Utils"),
                           .product(name: "Swinject", package: "Swinject"),
                           .product(name: "Account", package: "Account")
            ]),
    ]
)
