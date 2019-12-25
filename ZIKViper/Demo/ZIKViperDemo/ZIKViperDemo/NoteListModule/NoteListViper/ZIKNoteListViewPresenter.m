//
//  ZIKNoteListViewPresenter
//  ZIKViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017 zuik. All rights reserved.
//

#import "ZIKNoteListViewPresenter.h"
#import <ZIKViper/ZIKViperView.h>
#import <ZIKViper/ZIKViperPresenterPrivate.h>
@import ZIKRouter;
#import "ZIKNoteListViewProtocol.h"
#import "ZIKNoteListInteractorInput.h"

#import "ZIKLoginViewProtocol.h"
#import "NoteListRequiredNoteEditorDelegate.h"
#import "NoteListRequiredNoteEditorProtocol.h"

@interface ZIKNoteListViewPresenter () <ZIKViperPresenterPrivate,NoteListRequiredNoteEditorDelegate,ZIKLoginViewDelegate>
@property (nonatomic, strong) ZIKViewRouter *router;
@property (nonatomic, weak) id<ZIKViperView,ZIKNoteListViewProtocol> view;
@property (nonatomic, strong) id<ZIKViperInteractor,ZIKNoteListInteractorInput> interactor;

@property (nonatomic, strong, nullable) ZIKViewRouter *editorRouter;
@end

@implementation ZIKNoteListViewPresenter

#pragma mark ZIKViperViewEventHandler

- (void)handleViewReady {
    NSAssert(self.router, @"Router should be initlized when view is ready.");
    NSAssert([self.view conformsToProtocol:@protocol(ZIKNoteListViewProtocol)], @"Presenter should be attach to a view.");
    NSAssert([self.interactor conformsToProtocol:@protocol(ZIKNoteListInteractorInput)], @"Interactor should be initlized when view is ready.");
    [self.interactor loadAllNotes];
}

- (void)handleViewWillAppear:(BOOL)animated {
    
}

- (void)handleViewDidAppear:(BOOL)animated {
    if ([self.interactor needValidateAccount] == YES) {
        __weak typeof(self) weakSelf = self;
        UIViewController *source = self.view.routeSource;
        //You can create a required protocol for ZIKLoginViewProtocol inside NoteListModule, but it's not that necessary until you need to use another LoginModule
        [ZIKRouterToView(ZIKLoginViewProtocol)
         performPath:ZIKViewRoutePath.presentModallyFrom(source)
         strictConfiguring:^(ZIKViewRouteStrictConfiguration<id<ZIKLoginViewProtocol>> * _Nonnull config,
                             ZIKViewRouteConfiguration * _Nonnull module) {
             config.prepareDestination = ^(id<ZIKLoginViewProtocol> _Nonnull destination) {
                 destination.delegate = weakSelf;
                 destination.message = @"Login in to use this app";
             };
             config.errorHandler = ^(ZIKRouteAction routeAction, NSError * _Nonnull error) {
                 
             };
         }];
    }
}

- (void)handleViewWillDisappear:(BOOL)animated {
    
}

- (void)handleViewDidDisappear:(BOOL)animated {
    
}

- (void)handleViewRemoved {
    
}

- (void)didTouchNavigationBarAddButton {
    self.editorRouter = [ZIKRouterToViewModule(NoteListRequiredNoteEditorProtocol)
                         performPath:ZIKViewRoutePath.presentModallyFrom([self.view routeSource])
                         configuring:^(ZIKViewRouteConfiguration<NoteListRequiredNoteEditorProtocol> * _Nonnull config) {
                             config.containerWrapper = ^UIViewController<ZIKViewRouteContainer> * _Nonnull(UIViewController * _Nonnull destination) {
                                 return [[UINavigationController alloc] initWithRootViewController:destination];
                             };
                             config.delegate = self;
                             [config constructForCreatingNewNote];
                         }];
}

#pragma mark ZIKTNoteListViewDataSource

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.interactor.noteCount;
}

- (NSString *)textOfCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.interactor titleForNoteAtIndex:indexPath.row];
    return title;
}

- (NSString *)detailTextOfCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [self.interactor contentForNoteAtIndex:indexPath.row];
    return content;
}

#pragma mark ZIKTNoteListViewEventHandler

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)handleDeleteCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.interactor deleteNoteAtIndex:indexPath.row];
}

- (void)handleDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert([[self.view routeSource] isKindOfClass:[UIViewController class]], nil);
    
    self.editorRouter = [ZIKRouterToViewModule(NoteListRequiredNoteEditorProtocol)
                         performPath:ZIKViewRoutePath.pushFrom([self.view routeSource])
                         configuring:^(ZIKViewRouteConfiguration<NoteListRequiredNoteEditorProtocol> * _Nonnull config) {
                             config.delegate = self;
                             [config constructForEditingNote:[self.interactor noteAtIndex:indexPath.row]];
                         }];
}

#pragma mark ZIKLoginViewDelegate

- (void)loginViewController:(UIViewController *)loginViewController didLoginWithAccount:(NSString *)account {
    [self.interactor didLoginedWithAccount:account];
}

#pragma mark NoteListRequiredNoteEditorDelegate

- (void)editor:(UIViewController *)editor didFinishEditNote:(ZIKNoteModel *)note {
    if (self.editorRouter) {
        NSAssert([self.editorRouter canRemove] == YES, nil);
        [self.editorRouter removeRoute];
        self.editorRouter = nil;
    }
    
    [self.view.noteListTableView reloadData];
}

#pragma mark UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    __block UIViewController *destinationViewController;
    NSIndexPath *indexPath = [self.view.noteListTableView indexPathForRowAtPoint:location];
    
    destinationViewController = (UIViewController *)[ZIKRouterToViewModule(NoteListRequiredNoteEditorProtocol) makeDestinationWithConfiguring:^(ZIKViewRouteConfiguration<NoteListRequiredNoteEditorProtocol> * _Nonnull config) {
        config.previewing = YES;
        config.delegate = self;
        [config constructForEditingNote:[self.interactor noteAtIndex:indexPath.row]];
    }];
    NSAssert(destinationViewController != nil, nil);
    return destinationViewController;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    self.editorRouter = [ZIKRouterToViewModule(NoteListRequiredNoteEditorProtocol)
                         performOnDestination:(UIViewController<ZIKRoutableView> *)viewControllerToCommit
                         path:ZIKViewRoutePath.pushFrom(self.view.routeSource)];
}

@end
