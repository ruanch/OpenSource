//
//  ZIKTextWidgetInteractorInput.h
//  ZIKViperDemo
//
//  Created by zuik on 2017/7/17.
//  Copyright © 2017 zuik. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZIKTextWidgetInteractorInput <NSObject>
- (NSString *)copyrightDescription;
- (BOOL)needValidateAccount;
- (void)didLoginedWithAccount:(NSString *)account;
@end
