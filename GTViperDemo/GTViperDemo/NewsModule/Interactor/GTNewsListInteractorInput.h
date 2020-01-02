//
//  GTNewsListInteractorInput.h
//  GTViperDemo
//
//  Created by rch on 2019/12/17.
//  Copyright © 2019 nightelf. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef GTNewsListInteractorInput_h
#define GTNewsListInteractorInput_h

@protocol GTNewsListInteractorInput <NSObject>


- (NSInteger)newsCount;
- (NSString *)titleForNewsAtIndex:(NSUInteger)idx;
- (NSString *)contentForNewsAtIndex:(NSInteger)idx;

@end


#endif /* GTNewsListInteractorInput_h */
