//
//  GTNewsDataManager.h
//  GTViperDemo
//
//  Created by liuke on 2019/12/31.
//  Copyright © 2019 NightElf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTNewsEntity;
NS_ASSUME_NONNULL_BEGIN

@interface GTNewsDataManager : NSObject
@property (nonatomic,readonly,strong) NSArray<GTNewsEntity *> *newsList;
+ (instancetype) sharedInstace;
- (void) fetchAllNewsWithCompletion:(void(^)(NSArray *news))completion;
- (void) stroeNews:(GTNewsEntity *)news;
@end

NS_ASSUME_NONNULL_END
