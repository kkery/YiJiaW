//
//  CODBaseModel.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"

@implementation CODBaseModel
#pragma mark - Singleton archive
+ (NSString *)archivePath {
    NSString *pathOfDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [pathOfDocument stringByAppendingPathComponent:CODArchiveDirectory];
    [self checkDirectoryAtPath:path];
    // add do not backup attribute
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"failed to add do not backup attribute, error = %@", error);
    }
    return path;
}

+ (NSString *)archiveFile {
    NSString *cacheName = [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), @([[self class] archiveVersion])];
    return [[self archivePath] stringByAppendingPathComponent:cacheName];
}

- (BOOL)archive {
    return [NSKeyedArchiver archiveRootObject:self toFile:[[self class] archiveFile]];
}

+ (instancetype)unarchive {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] archiveFile]];
}

+ (BOOL)removeArchive {
    return [NSKeyedArchiver archiveRootObject:nil toFile:[[self class] archiveFile]];
}

+ (NSUInteger)archiveVersion {
    return 0;
}

#pragma mark - File
+ (void)checkDirectoryAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error;
            [fileManager removeItemAtPath:path error:&error];
            if (error) {
                NSLog(@"failed to remove directory, error = %@", error);
            }
            [self createBaseDirectoryAtPath:path];
        }
    }
}

+ (void)createBaseDirectoryAtPath:(NSString *)path {
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"failed to create directory, error = %@", error);
    }
}

@end
