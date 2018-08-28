# OPLevelDB

### Introduction
Objc wrapper for leveldb, support put, get, delete and writebatch.

It's also support **NSFastEnumeration**, you can use foreach to enum all keys & values in leveldb.

When put or get NSString to leveldb, you can use putString:forKey and getStringForKey:error.

These functions just convert NSString to std::string, and put it to leveldb, while other functions
use NSKeyedUnarchiver to put data. So it maybe fast than use putObject:forKey.

### Usage

#### Podfile

    pod 'OPLevelDB', :git => 'https://github.com/sunboshi/OPLevelDB.git'

#### Code

    #import <OPLevelDB/OPLevelDB.h>
    ...

    NSString *dbpath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.db"];
    OPLevelDB *db = [[OPLevelDB alloc] initWithPath:dbpath];
    NSString *key = @"key";
    NSString *val = @"val";
    NSError *err;

    err = [db putObject:val forKey:key];
    if (err != nil) {
        ...
    }

    NSString *dbVal = [db getObjectForKey:key error:&err];

    if (err != nil) {
        ...
    }

    NSLog(@"val=%@", dbVal);


See **OPLevelDBTests.m** for more example codes.
