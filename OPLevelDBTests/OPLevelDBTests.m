//
//  OPLevelDBTests.m
//  OPLevelDBTests
//
//  Created by sunboshi on 2018/8/23.
//  Copyright © 2018年 sunboshi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPLevelDB.h"

@interface OPLevelDBTests : XCTestCase

@property (nonatomic, strong) NSString *dbpath;

@end

@implementation OPLevelDBTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dbpath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.db"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPutGet {
    OPLevelDB *db = [[OPLevelDB alloc] initWithPath:self.dbpath];
    NSString *key = @"key";
    NSString *val = @"val";
    NSError *err;
    
    err = [db putObject:val forKey:key];
    XCTAssertNil(err);
    
    NSString *dbVal = [db getObjectForKey:key error:&err];
    XCTAssertTrue([val isEqualToString:dbVal]);
}

- (void)testDelete {
    OPLevelDB *db = [[OPLevelDB alloc] initWithPath:self.dbpath];
    NSString *key = @"key";
    NSString *val = @"val";
    NSError *err;
    
    err = [db putObject:val forKey:key];
    XCTAssertNil(err);
    
    err = [db deleteObjectForKey:key];
    XCTAssertNil(err);
    
    NSString *dbVal = [db getObjectForKey:key error:&err];
    XCTAssertNil(dbVal);
    
    XCTAssertTrue(err.code == OPLevelDBErrorCodeNotFound);
}

- (void)testString {
    OPLevelDB *db = [[OPLevelDB alloc] initWithPath:self.dbpath];
    NSString *key = @"key";
    NSString *val = @"val";
    NSError *err;
    
    err = [db putString:val forKey:key];
    XCTAssertNil(err);
    
    err = [db deleteObjectForKey:key];
    XCTAssertNil(err);
    
    NSString *dbVal = [db getStringForKey:key error:&err];
    XCTAssertNil(dbVal);
    
    XCTAssertFalse([val isEqualToString:dbVal]);
}

- (void)testBatch {
    OPLevelDB *db = [[OPLevelDB alloc] initWithPath:self.dbpath];
    OPLevelDBWriteBatch *batch = [[OPLevelDBWriteBatch alloc] init];
    
    NSString *key1 = @"key1";
    NSString *val1 = @"val1";
    
    NSString *key2 = @"key2";
    NSString *val2 = @"val2";
    
    NSString *key3 = @"key3";
    NSString *val3 = @"val3";
    
    NSError *err;
    
    err = [db putString:val1 forKey:key1];
    XCTAssertNil(err);
    
    [batch putObject:val2 forKey:key2];
    [batch putObject:val3 forKey:key3];
    [batch deleteObject:key1];
    
    [db writeBatch:batch];
    
    NSString *dbVal2 = [db getStringForKey:key2 error:&err];
    XCTAssertNil(dbVal2);
    XCTAssertFalse([val2 isEqualToString:dbVal2]);
    
    NSString *dbVal3 = [db getStringForKey:key3 error:&err];
    XCTAssertNil(dbVal3);
    XCTAssertFalse([val3 isEqualToString:dbVal3]);
    
    NSString *dbVal1 = [db getObjectForKey:key1 error:&err];
    XCTAssertNil(dbVal1);
    
    XCTAssertTrue(err.code == OPLevelDBErrorCodeNotFound);
}

- (void)testDestroy {
    NSError *err = [OPLevelDB destroyDB:self.dbpath];
    XCTAssertNil(err);
    
    OPLevelDB *db = [[OPLevelDB alloc] initWithPath:self.dbpath];
    err = [db putString:@"testDestroy" forKey:@"destroy"];
    XCTAssertNil(err);

    err = [OPLevelDB destroyDB:self.dbpath];
    XCTAssertNotNil(err);
}

- (void)testFastEnumeration {
    NSError *err = [OPLevelDB destroyDB:self.dbpath];
    XCTAssertNil(err);
    
    OPLevelDB *db = [[OPLevelDB alloc] initWithPath:self.dbpath];
    
    NSInteger count = 100;
    
    for (int i = 0; i < count; i++) {
        NSString *k = [NSString stringWithFormat:@"key%d", i];
        NSString *v = [NSString stringWithFormat:@"val%d", i];
        [db putString:v forKey:k];
    }
    
    NSInteger n = 0;
    for (OPLevelDBIteratorItem *item in db) {
        n++;
        XCTAssertNotNil(item.key);
        XCTAssertNotNil(item.value);
    }
    
    XCTAssertTrue(n == count);

}

@end
