//
//  ZIKTNoteListInteractor
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//


/**
   Interactor职责
        1.ZIKTViperInteractorPrivate  事件源和数据源，set的私有化
                  2.ZIKTNoteModel Entity的持有
                    3.ZIKTNoteListDataService service的持有,增删改查服务封装
        描述数据的接口定义入口，具体的事交给Service来做
 */
#import "ZIKTNoteListInteractor.h"
@import ZIKTViper.ZIKTViperInteractorPrivate;
#import "ZIKTNoteModel.h"
#import "ZIKTNoteListDataService.h"

@interface ZIKTNoteListInteractor () <ZIKTViperInteractorPrivate>
@property (nonatomic, strong, nullable) ZIKTNoteModel *currentEditingNote;
@property (nonatomic, strong) id<ZIKTNoteListDataService> noteListDataService;
@end

@implementation ZIKTNoteListInteractor
///初始化Service
- (instancetype)initWithNoteListDataService:(id<ZIKTNoteListDataService>)service {
    if (self = [super init]) {
        _noteListDataService = service;
    }
    return self;
}
///返回列表数据
- (NSArray<ZIKTNoteModel *> *)noteList {
    return self.noteListDataService.noteList;
}
///加载数据
- (void)loadAllNotes {
    [self.noteListDataService fetchAllNotesWithCompletion:^(NSArray *notes) {
        
    }];
}
///返回列表数量
- (NSInteger)noteCount {
    return self.noteList.count;
}
///返回标题
- (NSString *)titleForNoteAtIndex:(NSUInteger)idx {
    if (self.noteList.count - 1 < idx) {
        return nil;
    }
    return [[self.noteList objectAtIndex:idx] title];
}
///返回内容
- (NSString *)contentForNoteAtIndex:(NSUInteger)idx {
    if (self.noteList.count - 1 < idx) {
        return nil;
    }
    return [[self.noteList objectAtIndex:idx] content];
}
///返回指定对象
- (ZIKTNoteModel *)noteAtIndex:(NSUInteger)idx {
    if (self.noteList.count - 1 < idx) {
        return nil;
    }
    return [self.noteList objectAtIndex:idx];
}
///返回UUID
- (NSString *)noteUUIDAtIndex:(NSUInteger)idx {
    if (self.noteList.count - 1 < idx) {
        return nil;
    }
    return [[self.noteList objectAtIndex:idx] uuid];
}
///返回标题
- (NSString *)noteTitleAtIndex:(NSUInteger)idx {
    if (self.noteList.count - 1 < idx) {
        return nil;
    }
    return [[self.noteList objectAtIndex:idx] title];
}
///返回内容
- (NSString *)noteContentAtIndex:(NSUInteger)idx {
    if (self.noteList.count - 1 < idx) {
        return nil;
    }
    return [[self.noteList objectAtIndex:idx] content];
}
///删除数据
- (void)deleteNoteAtIndex:(NSUInteger)idx {
    if (self.noteList.count - 1 < idx) {
        return;
    }
    ZIKTNoteModel *note = [self noteAtIndex:idx];
    [self.noteListDataService deleteNote:note];
}

@end
