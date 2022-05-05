// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var dependencies: [Package.Dependency] = [.package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")]

private let remoteDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/arman095095/Managers.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Module.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/DesignSystem.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/AlertManager.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Utils.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/AccountRouteMap.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/UserStoryFacade.git", branch: "develop")
]

private let localDependencies: [Package.Dependency] = [
    .package(path: "../Managers"),
    .package(path: "../Module"),
    .package(path: "../DesignSystem"),
    .package(path: "../AlertManager"),
    .package(path: "../Utils"),
    .package(path: "../AccountRouteMap"),
    .package(path: "../UserStoryFacade")
]

let isDev = true
isDev ? dependencies.append(contentsOf: localDependencies) : dependencies.append(contentsOf: remoteDependencies)

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
                           .product(name: "AccountRouteMap", package: "AccountRouteMap"),
                           .product(name: "UserStoryFacade", package: "UserStoryFacade")
            ]),
    ]
)
