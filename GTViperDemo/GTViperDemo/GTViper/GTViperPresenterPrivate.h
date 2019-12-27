//
//  GTViperPresenterPrivate.h
//  GTViper
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTViperPresenter.h"
#import "GTViperInteractor.h"

NS_ASSUME_NONNULL_BEGIN

///私有化getter/setter的方法，只能在presenter中使用。
///Private getter/setter to configure GTViperPresenter. Should only be used inside presenter or assembly.
@protocol GTViperPresenterPrivate <GTViperPresenter>

- (id)router;
- (void)setRouter:(id)router;

- (void)setView:(id<GTViperView>)view;

- (id<GTViperInteractor>)interactor;
- (void)setInteractor:(id<GTViperInteractor>)interactor;

@end

NS_ASSUME_NONNULL_END
