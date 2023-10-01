//
//  RocksDBEnv+Private.h
//  ObjectiveRocks
//
//  Created by Pablo Carcelén on 01/10/2023.
//

#import "RocksDBEnv.h"

namespace rocksdb
{
    class Env;
}

/**
 This category is intended to hide all C++ types from the public interface in order to
 maintain a pure Objective-C API for Swift compatibility.
 */
@interface RocksDBEnv (Private)
@property (nonatomic, assign) rocksdb::Env *env;
@end
