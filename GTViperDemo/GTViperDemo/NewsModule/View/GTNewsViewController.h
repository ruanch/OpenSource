//
//  GTNewsViewController.h
//  GTViperDemo
//
//  Created by liuke on 2019/12/27.
//  Copyright © 2019 NightElf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTViperView.h"
#import "GTNewsListViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTNewsViewController : UIViewController <GTViperView,GTNewsListViewProtocol>

@end

NS_ASSUME_NONNULL_END
