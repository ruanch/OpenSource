//
//  GTViperViewEventHandler.h
//  GTViper
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import <Foundation/Foundation.h>

///Handle event from GTViperView
@protocol GTViperViewEventHandler <NSObject>

///把View的生命周期代理出去，在Presenter中实现生命周期
@optional
- (void)handleViewReady;
- (void)handleViewRemoved;
- (void)handleViewWillAppear:(BOOL)animated;
- (void)handleViewDidAppear:(BOOL)animated;
- (void)handleViewWillDisappear:(BOOL)animated;
- (void)handleViewDidDisappear:(BOOL)animated;

@end
