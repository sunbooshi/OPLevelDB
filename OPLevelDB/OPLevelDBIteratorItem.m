//
//  OPLevelDBIteratorItem.m
//  OPLevelDB
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import "OPLevelDBIteratorItem.h"

@implementation OPLevelDBIteratorItem

- (instancetype)initWithKey:(NSString *)key value:(id)value {
    self = [super init];
    if (self) {
        _key = key;
        _value = value;
    }
    return self;
}

@end
