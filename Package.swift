// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "RemoteRiftConnector",
    platforms: [.macOS(.v14)],
    products: [
        .executable(
            name: "RemoteRiftConnector",
            targets: ["RemoteRiftConnector"],
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.15.0"),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird-websocket.git", from: "2.6.0",
        ),
        .package(url: "https://github.com/tomwyr/union-codable.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "RemoteRiftConnector",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdWebSocket", package: "hummingbird-websocket"),
                .product(name: "UnionCodable", package: "union-codable"),
            ],
        ),
        .testTarget(
            name: "RemoteRiftConnectorTests",
            dependencies: ["RemoteRiftConnector"],
        ),
    ],
)
