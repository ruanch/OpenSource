//
//  ZIKTNoteListInteractor
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//

/**
        1. ZIKTViper.ZIKTViperInteractor; 持有数据源和事件源
                  2.ZIKTNoteListInteractorInput 输入事件
 */
#import <Foundation/Foundation.h>
@import ZIKTViper.ZIKTViperInteractor;
#import "ZIKTNoteListInteractorInput.h"

NS_ASSUME_NONNULL_BEGIN

@class ZIKTNoteModel;
@protocol ZIKTNoteListDataService;
@interface ZIKTNoteListInteractor : NSObject <ZIKTViperInteractor, ZIKTNoteListInteractorInput>
@property (nonatomic, weak) id dataSource;
@property (nonatomic, weak) id eventHandler;
- (void)loadAllNotes;
- (instancetype)initWithNoteListDataService:(id<ZIKTNoteListDataService>)service NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
