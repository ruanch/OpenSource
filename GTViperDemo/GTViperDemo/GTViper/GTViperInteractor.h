//
//  GTViperInteractor.h
//  GTViper
//
//  Created by rch on 2019/12/27.
//  Copyright © 2019 zuik. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTViperInteractor <NSObject>
@property (nonatomic, readonly, weak) id dataSource;
@property (nonatomic, readonly, weak) id eventHandler;
@end

NS_ASSUME_NONNULL_END
