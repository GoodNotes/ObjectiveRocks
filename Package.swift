// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObjectiveRocks",
    platforms: [.iOS(.v15), .macCatalyst(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ObjectiveRocks",
            targets: ["ObjectiveRocks"]),
    ],
    dependencies: [
        .package(url: "https://github.com/goodnotes/lz4-swift", from: "1.9.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ObjectiveRocks",
            dependencies: [
                "RocksDB",
                .product(name: "lz4", package: "lz4-swift")
            ],
            path: "Code",
            publicHeadersPath: "./"
        ),
        .testTarget(
            name: "ObjectiveRocksTests",
            dependencies: ["ObjectiveRocks"],
            path: "Tests",
            exclude: [
                "Info.plist",
                "RocksDBIndexedWriteBatchTests.m",
                "RocksDBReadOnlyTests.m",
                "RocksDBBackupTests.mm",
                "RocksDBBasicTests.mm",
                "RocksDBCheckpointTests.mm",
                "RocksDBColumnFamilyMetadataTests.mm",
                "RocksDBColumnFamilyTests.mm",
                "RocksDBComparatorTests.mm",
                "RocksDBIteratorTests.mm",
                "RocksDBMergeOperatorTests.mm",
                "RocksDBPrefixExtractorTests.mm",
                "RocksDBPropertiesTests.mm",
                "RocksDBSnapshotTests.mm",
                "RocksDBStatisticsTests.mm",
                "RocksDBTests.mm",
                "RocksDBWriteBatchTests.mm",
            ]
        ),
        .binaryTarget(
            name: "RocksDB",
            url: "https://github.com/GoodNotes/rocksdb/releases/download/v11.0.7/RocksDB.xcframework.zip",
            checksum: "850f309fe54b6b1cbbdaad39d2aa346d844486e211435ae67d428ad38aba0da3"
        )
    ],
    cxxLanguageStandard: .cxx20
)
