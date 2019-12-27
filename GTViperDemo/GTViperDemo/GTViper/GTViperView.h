//
//  GTViperView.h
//  GTViper
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTViperViewEventHandler;

///viper 的 view 模块
@protocol GTViperView <NSObject>

- (nullable UIViewController *)routeSource;
@property (nonatomic, readonly, strong) id<GTViperViewEventHandler> eventHandler;
///可以没有数据源的view/VC,所以可以不实现该协议
@optional
@property (nonatomic, readonly, strong) id viewDataSource;

@end

NS_ASSUME_NONNULL_END
