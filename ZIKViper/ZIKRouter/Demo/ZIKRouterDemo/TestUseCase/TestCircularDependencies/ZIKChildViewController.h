//
//  ZIKChildViewController.h
//  ZIKRouterDemo
//
//  Created by zuik on 2017/10/14.
//  Copyright © 2017 zuik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKChildViewProtocol.h"

@interface ZIKChildViewController : UIViewController <ZIKChildViewProtocol>
@property (nonatomic, strong) id<ZIKParentViewProtocol> parent;
@end
