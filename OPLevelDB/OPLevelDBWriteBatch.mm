//
//  OPLevelDBWriteBatch.m
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import "OPLevelDBWriteBatch.h"
#import "OPLevelDBHelper.h"

#include "leveldb/write_batch.h"

@interface OPLevelDBWriteBatch() {
    leveldb::WriteBatch _batch;
}

@end

@implementation OPLevelDBWriteBatch

- (void)putObject:(id<NSCoding>)obj forKey:(NSString *)key {
    leveldb::Slice k = [OPLevelDBHelper stringToSlice:key];
    leveldb::Slice v = [OPLevelDBHelper objectToSlice:obj];
    _batch.Put(k, v);
}

- (void)deleteObject:(NSString *)key {
    leveldb::Slice k = [OPLevelDBHelper stringToSlice:key];
    _batch.Delete(k);
}

- (void *)getWriteBatch {
    return &_batch;
}

@end
