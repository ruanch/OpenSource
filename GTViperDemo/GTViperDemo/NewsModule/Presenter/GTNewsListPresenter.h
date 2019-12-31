//
//  GTNewsListPresenter.h
//  GTViperDemo
//
//  Created by rch on 2019/12/17.
//  Copyright © 2019 nightelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTViperPresenter.h"
#import "GTNewsListViewEventHandler.h"
#import "GTNewsListViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTNewsListPresenter : NSObject <GTViperPresenter,GTNewsListViewEventHandler,GTNewsListViewDataSource>


@end

NS_ASSUME_NONNULL_END
