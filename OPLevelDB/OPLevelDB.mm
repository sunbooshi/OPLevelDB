//
//  OPLevelDB.m
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import "OPLevelDB.h"
#import <CoreFoundation/CoreFoundation.h>
#import "leveldb/db.h"
#import "leveldb/write_batch.h"
#import "leveldb/iterator.h"
#import "OPLevelDBHelper.h"

NSString * const OPLevelDBErrorDomain = @"tech.sunboshi.leveldb";

@interface OPLevelDB() {
    leveldb::DB *_db;
    leveldb::Iterator *_iterator;
}

@property (nonatomic, strong) NSMutableArray *iteratorItems;
@property (nonatomic, strong) NSString *dbPath;

@end


@implementation OPLevelDB

- (instancetype)initWithPath:(NSString *)path {
    NSAssert(path != nil, @"path is nil!");
    self = [super init];
    if (self) {
        _iterator = NULL;
        _db = [self createDBWithPath:path];
        self.dbPath = path;
        self.iteratorItems = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    if (_iterator != NULL) {
        delete _iterator;
    }
    
    if (_db != NULL) {
        delete _db;
    }
}

+ (NSError *)destroyDB:(NSString *)path {
    leveldb::Options op = leveldb::Options();
    std::string p = std::string([path UTF8String], [path lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    leveldb::Status status = leveldb::DestroyDB(p, op);
    return [OPLevelDB errorFromStatus:status desc:@"Destroy DB error."];
}

- (leveldb::DB *)createDBWithPath:(NSString *)path {
    leveldb::Options options;
    options.create_if_missing = true;
    leveldb::DB *db;
    leveldb::Status status = leveldb::DB::Open(options, [path UTF8String], &db);
    assert(status.ok());
    return db;
}

- (NSString *)dbPath {
    return [self.dbPath copy];
}

+ (NSError *)errorFromStatus:(leveldb::Status)status desc:(NSString *)desc {
    if (!status.ok()) {
        NSString *reason = [NSString stringWithFormat:@"leveldb status: %s", status.ToString().c_str()];
        if (desc == nil) {
            desc = reason;
        }
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: desc, NSLocalizedFailureReasonErrorKey: reason };
        NSInteger code = OPLevelDBErrorCodeUnknown;
        if (status.IsNotFound()) {
            code = OPLevelDBErrorCodeNotFound;
        }
        else if (status.IsCorruption()) {
            code = OPLevelDBErrorCodeCorruption;
        }
        else if (status.IsIOError()) {
            code = OPLevelDBErrorCodeIOError;
        }
        else if (status.IsNotSupportedError()) {
            code = OPLevelDBErrorCodeNotSupported;
        }
        else if (status.IsInvalidArgument()) {
            code = OPLevelDBErrorCodeInvalidArgument;
        }
        return [NSError errorWithDomain:OPLevelDBErrorDomain code:code userInfo:userInfo];
    }
    return nil;
}

- (NSError *)checkDB {
    if (_db == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Database not initialize or been destroyed.", NSLocalizedFailureReasonErrorKey:  @"Database not initialize or been destroyed."};
        return [NSError errorWithDomain:OPLevelDBErrorDomain code:OPLevelDBErrorCodeDBNotInit userInfo:userInfo];
    }
    return nil;
}

- (NSError *)putObject:(id)obj forKey:(NSString *)key {
    return [self putObject:obj forKey:key sync:NO];
}

- (NSError *)putObjectSync:(id)obj forKey:(NSString *)key {
    return [self putObject:obj forKey:key sync:YES];
}

- (NSError *)putObject:(id)obj forKey:(NSString *)key sync:(BOOL)sync {
    if (NSError * err = [self checkDB]) {
        return err;
    }
    
    leveldb::WriteOptions wo;
    wo.sync = sync ? true : false;
    
    leveldb::Slice k = [OPLevelDBHelper stringToSlice:key];
    leveldb::Slice v = [OPLevelDBHelper objectToSlice:obj];
    
    leveldb::Status status = _db->Put(wo, k, v);
    
    return [OPLevelDB errorFromStatus:status desc:[NSString stringWithFormat:@"get key [%@] error", key]];
}

- (NSError *)deleteObjectForKey:(NSString *)key {
    return [self deleteObjectForKey:key sync:NO];
}

- (NSError *)deleteObjectForKeySync:(NSString *)key {
    return [self deleteObjectForKey:key sync:YES];
}

- (NSError *)deleteObjectForKey:(NSString *)key sync:(BOOL)sync {
    if (NSError * err = [self checkDB]) {
        return err;
    }
    
    leveldb::WriteOptions wo;
    wo.sync = sync ? true : false;
    
    leveldb::Slice k = [OPLevelDBHelper stringToSlice:key];
    leveldb::Status status = _db->Delete(wo, k);
    
    return [OPLevelDB errorFromStatus:status desc:[NSString stringWithFormat:@"delete key [%@] error", key]];
}

- (id)getObjectForKey:(NSString *)key error:(NSError **)error {
    if (NSError * err = [self checkDB]) {
        *error = err;
        return nil;
    }
    
    leveldb::ReadOptions ro;
    std::string val;
    
    leveldb::Slice k = [OPLevelDBHelper stringToSlice:key];
    leveldb::Status status = _db->Get(ro, k, &val);
    
    NSError *err = [OPLevelDB errorFromStatus:status desc:[NSString stringWithFormat:@"get key [%@] error", key]];
    if (err) {
        if (error != nil) *error = err;
    }
    else {
        return [OPLevelDBHelper objectFromSlice:leveldb::Slice(val)];
    }
    
    return nil;
}

- (NSError *)deleteObject:(NSString *)key {
    return [self deleteObject:key sync:YES];
}

- (NSError *)deleteObject:(NSString *)key sync:(BOOL)sync {
    if (NSError *err = [self checkDB]) {
        return err;
    }
    
    leveldb::WriteOptions wo;
    wo.sync = sync ? true : false;
    
    leveldb::Slice k = [OPLevelDBHelper stringToSlice:key];
    leveldb::Status status = _db->Delete(wo, k);
    
    return [OPLevelDB errorFromStatus:status desc:[NSString stringWithFormat:@"del key [%@] error", key]];
}

- (NSError *)writeBatch:(OPLevelDBWriteBatch *)writeBatch {
    if (NSError *err = [self checkDB]) {
        return err;
    }
    
    leveldb::WriteOptions wo;
    leveldb::WriteBatch *wb = (leveldb::WriteBatch *)[writeBatch getWriteBatch];
    leveldb::Status status = _db->Write(wo, wb);
    return [OPLevelDB errorFromStatus:status desc:nil];
}

#pragma makr -
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id  _Nullable __unsafe_unretained [])buffer
                                    count:(NSUInteger)len {
    if (_db == NULL) {
        return 0;
    }
    
    if (state->state == 0) {
        if (_iterator != NULL) {
            delete _iterator;
        }
        _iterator = _db->NewIterator(leveldb::ReadOptions());
        state->mutationsPtr = &state->extra[0];
        _iterator->SeekToFirst();
        state->state = 1;
    }
    
    NSUInteger count = 0;
    state->itemsPtr = buffer;
    [self.iteratorItems removeAllObjects];
    
    while (_iterator->Valid() && count < len) {
        NSString *key = [OPLevelDBHelper stringFromSlice:_iterator->key()];
        id val = [OPLevelDBHelper objectFromSlice:_iterator->value()];
        OPLevelDBIteratorItem *item = [[OPLevelDBIteratorItem alloc] initWithKey:key value:val];
        buffer[count] = item;
        // 避免对象被释放
        [self.iteratorItems addObject:item];
        count ++;
        _iterator->Next();
    }
    
    return count;
}

@end
