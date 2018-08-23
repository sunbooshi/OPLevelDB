//
//  OPLevelDBWriteBatch.h
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OPLevelDBWriteBatch : NSObject

- (void *)getWriteBatch;

- (void)putObject:(id<NSCoding>)obj forKey:(NSString *)key;
- (void)deleteObject:(NSString *)key;

@end
