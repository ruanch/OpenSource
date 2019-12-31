//
//  GTNewsViewController.h
//  GTViperDemo
//
//  Created by rch on 2019/12/17.
//  Copyright © 2019 nightelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTViperView.h"
#import "GTNewsListViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTNewsViewController : UIViewController <GTViperView,GTNewsListViewProtocol>

@end

NS_ASSUME_NONNULL_END
