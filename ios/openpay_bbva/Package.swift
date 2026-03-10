// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "openpay_bbva",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "openpay_bbva", targets: ["openpay_bbva"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/FMarcelFC/OpenpayPod",
            from: "0.0.6"
        )
    ],
    targets: [
        .target(
            name: "openpay_bbva",
            dependencies: [
                .product(name: "OpenpayKit", package: "OpenpayPod")
            ],
            path: "Classes",
            publicHeadersPath: "."
        )
    ]
)
