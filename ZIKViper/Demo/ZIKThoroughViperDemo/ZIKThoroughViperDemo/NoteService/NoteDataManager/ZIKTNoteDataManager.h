//
//  ZIKTNoteDataManager.h
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//
/**
        1.ZIKTNoteListDataService 该类就是实现Service协议内容。 单例实现
 */
#import <Foundation/Foundation.h>
#import "ZIKTNoteListDataService.h"

@class ZIKTNoteModel;
@interface ZIKTNoteDataManager : NSObject <ZIKTNoteListDataService>
@property (nonatomic, readonly, strong) NSArray<ZIKTNoteModel *> *noteList;
+ (instancetype)sharedInsatnce;
- (void)fetchAllNotesWithCompletion:(void(^)(NSArray *notes))completion;
- (void)storeNote:(ZIKTNoteModel *)note;
- (void)deleteNote:(ZIKTNoteModel *)noteToDelete;
@end
