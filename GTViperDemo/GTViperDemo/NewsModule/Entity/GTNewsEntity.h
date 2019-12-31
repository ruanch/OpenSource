//
//  GTNewsEntity.h
//  GTViperDemo
//
//  Created by liuke on 2019/12/31.
//  Copyright © 2019 NightElf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTNewsEntity : NSObject
@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *content;
- (instancetype)initWithUUID:(NSString *)uuid title:(NSString *)title content:(NSString *)content NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNewNoteForTitle:(NSString *)title content:(NSString *)content;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
