//
//  GTNewsDataManager.m
//  GTViperDemo
//
//  Created by liuke on 2019/12/31.
//  Copyright © 2019 NightElf. All rights reserved.
//

#import "GTNewsDataManager.h"
#import "GTNewsEntity.h"
@interface GTNewsDataManager()
@property(nonatomic,strong) NSMutableArray *newsUids;
@property(nonatomic,strong) NSMutableArray<GTNewsEntity *> *news;
@end
@implementation GTNewsDataManager
+ (instancetype) sharedInstace
{
    static GTNewsDataManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GTNewsDataManager alloc] init];
    });
    return shared;
}

- (void)fetchAllNewsWithCompletion:(void (^)(NSArray * _Nonnull))completion
{
    //确保主线调用
    NSAssert([NSThread isMainThread], @"main thread only, otherwise use lock to make thread safety.");
    //懒加载
    NSArray *newsList = self.newsList;
    if (!newsList) {
        self.newsUids = NSMutableArray.array;
        self.news = NSMutableArray.array;
        
        NSArray<NSString *> *uids = [self newsListUidArray];
        NSMutableArray *news = NSMutableArray.array;
        for (NSString *uid in  uids) {
            GTNewsEntity *entity = [self localStoredNewsWithUid:uid];
            if (entity) {
                [news addObject:entity];
            }
        }
        [self.newsUids addObjectsFromArray:uids];
        [self.news addObjectsFromArray:news];
        newsList = news;
    }
    if (completion) {
        completion(newsList);
    }
}
- (void)stroeNews:(GTNewsEntity *)entity
{
    NSAssert([NSThread isMainThread], @"main thread only, otherwise use lock to make thread safety.");
    NSString *filePath = [GTNewsDataManager _o_pathForLocalStoredNewsWithUUID:entity.uuid];
    BOOL success = [NSKeyedArchiver archiveRootObject:entity toFile:filePath];
    NSAssert(success == YES, nil);
    if (success) {
        if (![self.newsUids containsObject:entity.uuid]) {
            [self.newsUids addObject:entity.uuid];
            [self.news addObject:entity];
            [self storeNoteListUUIDs];
        }else {
            NSUInteger idx;
            for (idx = 0; idx < self.news.count; idx++){
                GTNewsEntity *exsitEntity = [self.news objectAtIndex:idx];
                if ([exsitEntity.uuid isEqualToString:entity.uuid]) {
                    break;
                }
                [self.news replaceObjectAtIndex:idx withObject:entity];
            }
        }
    }
    
    
    
}




#pragma mark - tool method
-(NSArray<NSString *> *)newsListUidArray
{
    NSAssert([NSThread currentThread], @"main thread only, otherwise use lock to make thread safety.");
    NSArray * newsListUids = [NSKeyedUnarchiver unarchiveObjectWithFile:[GTNewsDataManager _o_pathForLocalStoreNews]];
    return newsListUids;
}

- (GTNewsEntity *)localStoredNewsWithUid:(NSString *)uid
{
   NSParameterAssert(uid);
   NSAssert([NSThread isMainThread], @"main thread only, otherwise use lock to make thread safety.");
    GTNewsEntity *entity = [NSKeyedUnarchiver unarchiveObjectWithFile:[GTNewsDataManager _o_pathForLocalStoredNewsWithUUID:uid]];
    return entity;
}

- (void)storeNoteListUUIDs {
    NSAssert([NSThread isMainThread], @"main thread only, otherwise use lock to make thread safety.");
    NSString *filePath = [GTNewsDataManager _o_pathForLocalStoreNews];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.newsUids toFile:filePath];
    NSAssert(success == YES, nil);
}


#pragma mark - filepath

+ (NSString *)_o_pathForLocalStoreNews {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [document stringByAppendingPathComponent:@"Notes"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(error == nil, nil);
    });
    return path;
}

+ (NSString *)_o_pathForLocalStoredNewsWithUUID:(NSString *)uuid {
    NSParameterAssert(uuid);
    return [[self _o_pathForLocalStoreNews] stringByAppendingPathComponent:uuid];
}
@end
