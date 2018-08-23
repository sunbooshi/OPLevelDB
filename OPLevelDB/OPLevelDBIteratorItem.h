//
//  OPLevelDBIteratorItem.h
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPLevelDBIteratorItem : NSObject

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong, readonly) id value;

- (instancetype)initWithKey:(NSString *)key value:(id)value;

@end
