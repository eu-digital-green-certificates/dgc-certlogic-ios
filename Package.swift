// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CertLogic",
  defaultLocalization: "en",
  platforms: [
    .macOS(.v10_13), .iOS(.v11), .tvOS(.v9), .watchOS(.v2)
  ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CertLogic",
            targets: ["CertLogic"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
      .package(name: "jsonlogic", url: "https://github.com/eu-digital-green-certificates/json-logic-swift.git", from: "1.1.5"),
      .package(name: "SwiftyJSON", url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CertLogic",
          dependencies: ["jsonlogic", "SwiftyJSON"],
          resources: [.process("Resources")]),
        .testTarget(
            name: "CertLogicTests",
            dependencies: ["CertLogic", "jsonlogic", "SwiftyJSON"]),
    ]
)
