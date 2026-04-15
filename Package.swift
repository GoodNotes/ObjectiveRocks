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
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ObjectiveRocks",
            dependencies: [
                "RocksDB"
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
            url: "https://github.com/GoodNotes/rocksdb/releases/download/v11.0.8/RocksDB.xcframework.zip",
            checksum: "ddc7f1aa1f28c8f8596471707e0ca0e8afea0b44ad576cae5ff0319cc193f927"
        )
    ],
    cxxLanguageStandard: .cxx20
)
