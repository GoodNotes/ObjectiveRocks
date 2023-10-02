//
//  RocksDBEnv.m
//  ObjectiveRocks
//
//  Created by Iska on 05/01/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

#import "RocksDBEnv.h"

#import "RocksDBThreadStatus.h"
#import <rocksdb/env.h>
#import <rocksdb/thread_status.h>

#pragma mark - Informal Protocols

@interface RocksDBEnv ()
{
	rocksdb::Env *_env;
}
@property (nonatomic, assign) rocksdb::Env *env;
@end

@interface RocksDBThreadStatus ()
@property (nonatomic, assign) uint64_t threadId;
@property (nonatomic, assign) RocksDBThreadType threadType;
@property (nonatomic, copy) NSString *databaseName;
@property (nonatomic, copy) NSString *columnFamilyname;
@property (nonatomic, assign) RocksDBOperationType operationType;
@property (nonatomic, assign) RocksDBStateType stateType;
@end

#pragma mark - Impl

@implementation RocksDBEnv
@synthesize env = _env;

#pragma mark - Lifecycle

+ (instancetype)envWithLowPriorityThreadCount:(int)lowPrio andHighPriorityThreadCount:(int)highPrio
{
	RocksDBEnv *instance = [RocksDBEnv new];
	[instance setLowPriorityPoolThreadsCount:lowPrio];
	[instance setHighPriorityPoolThreadsCount:highPrio];
	return instance;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		_env = rocksdb::Env::Default();
	}
	return self;
}

- (void)dealloc
{
	@synchronized(self) {
		if (_env != nullptr && _env != rocksdb::Env::Default()) {
			delete _env;
			_env = nullptr;
		}
	}
}

#pragma mark - Threads

- (void)setHighPriorityPoolThreadsCount:(int)numThreads
{
	if (numThreads <= 0) numThreads = 1;
	_env->SetBackgroundThreads(numThreads, rocksdb::Env::HIGH);
}

- (void)setLowPriorityPoolThreadsCount:(int)numThreads
{
	if (numThreads <= 0) numThreads = 1;
	_env->SetBackgroundThreads(numThreads, rocksdb::Env::LOW);
}

- (NSArray *)threadList
{
	std::vector<rocksdb::ThreadStatus> thread_list;
	_env->GetThreadList(&thread_list);

	NSMutableArray *threadList = [NSMutableArray array];
	for (auto it = std::begin(thread_list); it != std::end(thread_list); ++it) {
		RocksDBThreadStatus *thread = [RocksDBThreadStatus new];
		thread.threadId = (*it).thread_id;
		thread.threadType  = (RocksDBThreadType)(*it).thread_type;
		thread.databaseName = [NSString stringWithCString:(*it).db_name.c_str() encoding:NSUTF8StringEncoding];
		thread.columnFamilyname = [NSString stringWithCString:(*it).cf_name.c_str() encoding:NSUTF8StringEncoding];
		thread.operationType = (RocksDBOperationType)(*it).operation_type;
		thread.stateType = (RocksDBStateType)(*it).state_type;
		[threadList addObject:thread];
	}

	return threadList;
}

@end
