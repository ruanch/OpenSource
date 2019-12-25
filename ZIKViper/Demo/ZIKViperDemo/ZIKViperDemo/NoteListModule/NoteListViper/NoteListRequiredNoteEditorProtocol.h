//
//  NoteListRequiredNoteEditorProtocol.h
//  ZIKViperDemo
//
//  Created by zuik on 2017/7/24.
//  Copyright © 2017 zuik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteListRequiredNoteEditorDelegate.h"
@import ZIKRouter;

NS_ASSUME_NONNULL_BEGIN

@class ZIKNoteModel;
///Reqiured interface of editor module for notelist module
@protocol NoteListRequiredNoteEditorProtocol <ZIKViewModuleRoutable>
@property (nonatomic, assign) BOOL previewing;
@property (nonatomic, weak) id<NoteListRequiredNoteEditorDelegate> delegate;
- (void)constructForCreatingNewNote;
- (void)constructForEditingNote:(ZIKNoteModel *)note;
@end

NS_ASSUME_NONNULL_END
