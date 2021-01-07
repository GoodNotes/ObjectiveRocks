//
//  RocksDBBasicTests.swift
//  ObjectiveRocks
//
//  Created by Iska on 11/01/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

import XCTest
import ObjectiveRocks

class RocksDBBasicTests : RocksDBTests {

	func testSwift_DB_Open_ErrorIfExists() throws {
		rocks = try RocksDB.database(atPath: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})
		rocks.close()

		XCTAssertThrowsError(try RocksDB.database(atPath: self.path, andDBOptions: { (options) -> Void in
			options.errorIfExists = true
		}))
	}
    
    func testSwift_DB_IsClosed() throws {
        rocks = try RocksDB.database(atPath: self.path, andDBOptions: { (options) -> Void in
            options.createIfMissing = true
        })
        XCTAssertFalse(rocks.isClosed())
        rocks.close()
        XCTAssertTrue(rocks.isClosed())
        XCTAssertThrowsError(try rocks.data(forKey: "key 1"));
    }

	func testSwift_DB_CRUD() throws {
		rocks = try RocksDB.database(atPath: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})
		rocks.setDefault(
			readOptions: { (readOptions) -> Void in
				readOptions.fillCache = true
				readOptions.verifyChecksums = true
		},
			writeOptions: { (writeOptions) -> Void in
				writeOptions.syncWrites = true
		})

		try! rocks.setData("value 1", forKey: "key 1")
		try! rocks.setData("value 2", forKey: "key 2")
		try! rocks.setData("value 3", forKey: "key 3")

		XCTAssertEqual(try! rocks.data(forKey: "key 1"), "value 1".data);
		XCTAssertEqual(try! rocks.data(forKey: "key 2"), "value 2".data);
		XCTAssertEqual(try! rocks.data(forKey: "key 3"), "value 3".data);

		try! rocks.deleteData(forKey: "key 2")
		XCTAssertNil(try? rocks.data(forKey: "key 2"));

		try! self.rocks.deleteData(forKey: "key 2")
	}
}
