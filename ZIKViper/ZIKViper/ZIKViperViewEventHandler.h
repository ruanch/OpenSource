//
//  ZIKViperViewEventHandler.h
//  ZIKViper
//
//  Created by zuik on 2017/5/24.
//  Copyright © 2017 zuik. All rights reserved.
//

#import <Foundation/Foundation.h>

///Handle event from ZIKViperView
@protocol ZIKViperViewEventHandler <NSObject>

///把View的生命周期代理出去，在Presenter中实现生命周期
@optional
- (void)handleViewReady;
- (void)handleViewRemoved;
- (void)handleViewWillAppear:(BOOL)animated;
- (void)handleViewDidAppear:(BOOL)animated;
- (void)handleViewWillDisappear:(BOOL)animated;
- (void)handleViewDidDisappear:(BOOL)animated;

@end
