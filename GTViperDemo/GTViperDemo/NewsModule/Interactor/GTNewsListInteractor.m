//
//  GTNewsListInteractor.m
//  GTViperDemo
//
//  Created by liuke on 2019/12/31.
//  Copyright © 2019 NightElf. All rights reserved.
//

#import "GTNewsListInteractor.h"
#import "GTNewsManager.h"
#import "GTViperInteractorPrivate.h"

@interface GTNewsListInteractor()<GTViperInteractorPrivate>

@end

@implementation GTNewsListInteractor
- (void)loadAllNotes {
    [[ZIKNoteDataManager sharedInsatnce] fetchAllNotesWithCompletion:^(NSArray *notes) {
        
    }];
}
@end
