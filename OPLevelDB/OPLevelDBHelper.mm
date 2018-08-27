//
//  OPLevelDBHelper.m
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import "OPLevelDBHelper.h"

@implementation OPLevelDBHelper

+ (leveldb::Slice)stringToSlice:(NSString *)s {
    return leveldb::Slice([s UTF8String], [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

+ (NSString *)stringFromSlice:(leveldb::Slice)slice {
    return [[NSString alloc] initWithBytes:slice.data() length:slice.size() encoding:NSUTF8StringEncoding];
}

+ (leveldb::Slice)objectToSlice:(id)obj {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    return leveldb::Slice((char *)[data bytes], data.length);
}

+ (id)objectFromSlice:(leveldb::Slice)slice {
    NSData *data = [NSData dataWithBytes:slice.data() length:slice.size()];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (obj == nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
