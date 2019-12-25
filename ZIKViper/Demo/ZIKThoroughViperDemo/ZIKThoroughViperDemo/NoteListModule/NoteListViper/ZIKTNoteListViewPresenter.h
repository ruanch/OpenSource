//
//  ZIKTNoteListViewPresenter
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//


/**
   Presenter的职责：
 1.ZIKTViperPresenter实现基类私有方法，这个方法包含一个view（这个view其实不是成员变量，是一个getter/setter方法，可以通过对象实现这个协议，从而定一个成员变理，否则调用会崩溃)，所以在bulder的时候已经setView进来了。
 2.ZIKTNoteListViewEventHandler/ZIKTNoteListViewDataSource , 在这里实现具体方法
 
     !!!!!!处理View的事件源（交互事件）和 返回View上所需数据(但是具体数据交给Interactor）
 */

#import <Foundation/Foundation.h>
@import ZIKTViper.ZIKTViperPresenter;
#import "ZIKTNoteListViewEventHandler.h"
#import "ZIKTNoteListViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIKTNoteListViewPresenter : NSObject <ZIKTViperPresenter,ZIKTNoteListViewEventHandler,ZIKTNoteListViewDataSource>

@end

NS_ASSUME_NONNULL_END
