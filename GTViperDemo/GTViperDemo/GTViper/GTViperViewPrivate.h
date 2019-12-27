//
//  GTViperViewPrivate.h
//  GTViper
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTViperView.h"
#import "GTViperPresenterPrivate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GTViperViewEventHandler;

///私有化getter/setter的方法，只能在view中使用。
///Private getter/setter to configure GTViperView. Should only be used inside view or assembly.
@protocol GTViperViewPrivate <GTViperView>

- (void)setEventHandler:(id<GTViperViewEventHandler>)eventHandler;
@optional
- (void)setViewDataSource:(id)viewDataSource;

@end

NS_ASSUME_NONNULL_END
