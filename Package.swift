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
            url: "https://github.com/GoodNotes/rocksdb/releases/download/v11.1.1/RocksDB.xcframework.zip",
            checksum: "ec4e56fbe39d980ffa17e25803a9b115b4f09594266a5038f1f4c9a64f856ca6"
        )
    ],
    cxxLanguageStandard: .cxx20
)
