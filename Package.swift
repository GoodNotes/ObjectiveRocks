// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObjectiveRocks",
    platforms: [.iOS(.v15), .macCatalyst(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ObjectiveRocks",
            targets: ["ObjectiveRocks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ObjectiveRocks",
            dependencies: ["RocksDB", "RocksLZ4"],
            path: "Code",
            publicHeadersPath: "./"
        ),
        .testTarget(
            name: "ObjectiveRocksTests",
            dependencies: ["ObjectiveRocks"],
            path: "Tests",
            exclude: [
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
            url: "https://github.com/GoodNotes/rocksdb/releases/download/v8.10.0/RocksDB.xcframework.zip",
            checksum: "70b11dbb039a4e63fc7f4d100c49fb5dbd73db8a5cdefe24b6ee0eb32d1bda39"
        ),
        .target(
            name: "RocksLZ4",
            path: "lz4",
            sources: [
                "lz4.c",
                "lz4.h",
                "lz4hc.c",
                "lz4hc.h",
            ],
            publicHeadersPath: "."
        )
    ],
    cxxLanguageStandard: .cxx20
)
