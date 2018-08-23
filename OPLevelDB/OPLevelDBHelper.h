//
//  OPLevelDBHelper.h
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "leveldb/db.h"

@interface OPLevelDBHelper : NSObject

+ (leveldb::Slice)stringToSlice:(NSString *)s;
+ (NSString *)stringFromSlice:(leveldb::Slice)slice;
+ (leveldb::Slice)objectToSlice:(id)obj;
+ (id)objectFromSlice:(leveldb::Slice)slice;

@end
