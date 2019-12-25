//
//  ZIKTNoteListViewEventHandler.h
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//相当于继承了协议，(ZIKTViper.ZIKTViperViewEventHandler 是一个抽象协议,抽象了基本共用的一些协议方法)
@import ZIKTViper.ZIKTViperViewEventHandler;

@protocol ZIKTNoteListViewEventHandler <ZIKTViperViewEventHandler,UIViewControllerPreviewingDelegate>
- (void)didTouchNavigationBarAddButton;

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)handleDeleteCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)handleDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
