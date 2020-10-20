//
//  RocksDBReadOnlyTests.m
//  ObjectiveRocks
//
//  Created by Iska on 10/08/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

#import "RocksDBTests.h"

@interface RocksDBReadOnlyTests : RocksDBTests

@end

@implementation RocksDBReadOnlyTests

- (void)testDB_Open_ReadOnly_NilIfMissing
{
	_rocks = [RocksDB databaseForReadOnlyAtPath:_path andDBOptions:nil];
	XCTAssertNil(_rocks);
}

- (void)testDB_Open_ReadOnly
{
	_rocks = [RocksDB databaseAtPath:_path andDBOptions:^(RocksDBOptions *options) {
		options.createIfMissing = YES;
	}
							   error: nil];
	XCTAssertNotNil(_rocks);
	[_rocks close];

	_rocks = [RocksDB databaseForReadOnlyAtPath:_path andDBOptions:nil];
	XCTAssertNotNil(_rocks);
}

- (void)testDB_ReadOnly_NotWritable
{
	_rocks = [RocksDB databaseAtPath:_path andDBOptions:^(RocksDBOptions *options) {
		options.createIfMissing = YES;
	}
							   error: nil];
	XCTAssertNotNil(_rocks);
	[_rocks setData:@"data".data forKey:@"key".data error:nil];
	[_rocks close];

	_rocks = [RocksDB databaseForReadOnlyAtPath:_path andDBOptions:nil];

	NSError *error = nil;
	[_rocks dataForKey:@"key".data error:&error];
	XCTAssertNil(error);

	error = nil;
	[_rocks setData:@"data".data forKey:@"key".data error:&error];
	XCTAssertNotNil(error);

	error = nil;
	[_rocks deleteDataForKey:@"key".data error:&error];
	XCTAssertNotNil(error);

	error = nil;
	[_rocks mergeData:@"data".data forKey:@"key".data error:&error];
	XCTAssertNotNil(error);
}

@end
