// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "MoEKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MoEExtensions", targets: ["MoEExtensions"]),
        .library(name: "MoEUI", targets: ["MoEUI"]),
        .library(name: "MoEFonts", targets: ["MoEFonts"]),
        .library(name: "MoEAnimations", targets: ["MoEAnimations"]),
        .library(name: "MoELocalization", targets: ["MoELocalization"]),
        .library(name: "MoENetworking", targets: ["MoENetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
        .package(url: "https://github.com/efremidze/VisualEffectView.git", from: "4.1.4"),
    ],
    targets: [
        .target(
            name: "MoEExtensions",
            dependencies: [],
            path: "Sources/MoEExtensions"
        ),
        .target(
            name: "MoEUI",
            dependencies: [
                "MoEExtensions",
                .product(name: "VisualEffectView", package: "VisualEffectView"),
            ],
            path: "Sources/MoEUI"
        ),
        .target(
            name: "MoEFonts",
            dependencies: [],
            path: "Sources/MoEFonts"
        ),
        .target(
            name: "MoEAnimations",
            dependencies: [],
            path: "Sources/MoEAnimations"
        ),
        .target(
            name: "MoELocalization",
            dependencies: [],
            path: "Sources/MoELocalization"
        ),
        .target(
            name: "MoENetworking",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
            ],
            path: "Sources/MoENetworking"
        ),
    ]
)
