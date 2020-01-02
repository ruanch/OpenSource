//
//  GTNewsListInteractor.m
//  GTViperDemo
//
//  Created by liuke on 2019/12/31.
//  Copyright © 2019 NightElf. All rights reserved.
//

#import "GTNewsListInteractor.h"
#import "GTNewsDataManager.h"
#import "GTNewsEntity.h"
#import "GTViperInteractorPrivate.h"

@interface GTNewsListInteractor()<GTViperInteractorPrivate>

@end

@implementation GTNewsListInteractor
- (void)loadAllNews {
    [[GTNewsDataManager sharedInstace] fetchAllNewsWithCompletion:^(NSArray *news) {}];
}

- (NSArray<GTNewsEntity *> *)newsList {
    return [GTNewsDataManager sharedInstace].newsList;
}

- (NSInteger)newsCount
{
    return self.newsList.count;
}

- (NSString *)contentForNewsAtIndex:(NSInteger)idx {
    if (self.newsList.count - 1 < idx) {
        return nil;
    }
    
    return [self.newsList objectAtIndex:idx].content;
}


- (NSString *)titleForNewsAtIndex:(NSUInteger)idx {
     if (self.newsList.count - 1 < idx) {
            return nil;
        }
        return [self.newsList objectAtIndex:idx].title;
}

 
@end
