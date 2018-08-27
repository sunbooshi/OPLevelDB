//
//  OPLevelDB.h
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPLevelDBIteratorItem.h"
#import "OPLevelDBWriteBatch.h"

//! Project version number for OPLevelDB.
FOUNDATION_EXPORT double OPLevelDBVersionNumber;

//! Project version string for OPLevelDB.
FOUNDATION_EXPORT const unsigned char OPLevelDBVersionString[];

FOUNDATION_EXPORT NSString * const OPLevelDBErrorDomain;

NS_ERROR_ENUM(OPLevelDBErrorDomain)
{
    OPLevelDBErrorCodeUnknown           = 1050,
    OPLevelDBErrorCodeNotFound          = 1051,
    OPLevelDBErrorCodeCorruption        = 1052,
    OPLevelDBErrorCodeNotSupported      = 1053,
    OPLevelDBErrorCodeInvalidArgument   = 1054,
    OPLevelDBErrorCodeIOError           = 1055
};

@interface OPLevelDB : NSObject<NSFastEnumeration>

- (instancetype)initWithPath:(NSString *)path;
- (NSString *)dbPath;

+ (NSError *)destroyDB:(NSString *)path;

- (NSError *)putObject:(id<NSCoding>)obj forKey:(NSString *)key;

- (NSError *)putObjectSync:(id<NSCoding>)obj forKey:(NSString *)key;

- (NSError *)putObject:(id<NSCoding>)obj forKey:(NSString *)key sync:(BOOL)sync;

- (NSError *)deleteObjectForKey:(NSString *)key;

- (NSError *)deleteObjectForKeySync:(NSString *)key;

- (NSError *)deleteObjectForKey:(NSString *)key sync:(BOOL)sync;

- (id)getObjectForKey:(NSString *)key error:(NSError **)error;

- (NSError *)writeBatch:(OPLevelDBWriteBatch *)writeBatch;

- (NSError *)putString:(NSString *)str forKey:(NSString *)key;

- (NSError *)putStringSync:(NSString *)str forKey:(NSString *)key;

- (NSError *)putString:(NSString *)str forKey:(NSString *)key sync:(BOOL)sync;

- (NSString *)getStringForKey:(NSString *)key error:(NSError **)error;

@end



