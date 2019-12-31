//
//  GTNewsListInteractor.h
//  GTViperDemo
//
//  Created by liuke on 2019/12/31.
//  Copyright © 2019 NightElf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTViperInteractor.h"
#import "GTNewsListInteractorInput.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTNewsListInteractor : NSObject<GTViperInteractor,GTNewsListInteractorInput>

@property (nonatomic, weak) id dataSource;
@property (nonatomic, weak) id eventHandler;

- (void)loadAllNews;

@end

NS_ASSUME_NONNULL_END
