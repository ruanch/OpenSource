//
//  GTViperPresenter.h
//  GTViper
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTViperViewEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GTViperView;

@protocol GTViperPresenter <GTViperViewEventHandler>
///UIViewController or UIView, conform to view protocol
@property (nonatomic, readonly, weak) id<GTViperView> view;
@end

NS_ASSUME_NONNULL_END
