//
//  GTNoteListViewEventHandler.h
//  GTViperDemo
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTViperViewEventHandler.h"

@protocol GTNoteListViewEventHandler <GTViperViewEventHandler,UIViewControllerPreviewingDelegate>
- (void)didTouchNavigationBarAddButton;
- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)handleDeleteCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)handleDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
