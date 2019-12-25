//
//  ZIKTNoteListViewPresenter
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//


/**
    1.ZIKTViper.ZIKTViperView协议 在 view中需要用到 view是builder的时候分配了。
    2.ZIKTViper.ZIKTViperPresenterPrivate协议 需要用到 view , interactor ,wireframe的定义，这个也是builder中已分配好
    3. ZIKTNoteListWireframeInput 线架图协议，该类需要路由各个模块的定义，都这个协议里，（强引用Router)
    4.ZIKTNoteListViewProtocol 同1
    5.ZIKTNoteListInteractorInput 交互器协议，该类用于具体加载数据
 
         6.ZIKTLoginViewProtocol登录协议,另外模块
         7.ZIKTEditorDelegate文本输入协议，另外模块
 */

#import "ZIKTNoteListViewPresenter.h"
@import ZIKTViper.ZIKTViperView;
@import ZIKTViper.ZIKTViperPresenterPrivate;
#import "ZIKTNoteListWireframeInput.h"
#import "ZIKTNoteListViewProtocol.h"
#import "ZIKTNoteListInteractorInput.h"

#import "ZIKTLoginViewProtocol.h"
#import "ZIKTEditorDelegate.h"

@interface ZIKTNoteListViewPresenter () <ZIKTViperPresenterPrivate,ZIKTEditorDelegate,ZIKTLoginViewDelegate>
///线架图协议的代理(具体实现者：ZIKTNoteListWireframe)
@property (nonatomic, strong) id<ZIKTNoteListWireframeInput> wireframe;
///这里view 对应了  ZIKTNoteListViewController : UIViewController <ZIKTViperView,ZIKTNoteListViewProtocol>
@property (nonatomic, weak) id<ZIKTViperView,ZIKTNoteListViewProtocol> view;
///交互器协议代表(具体实现者：ZIKTNoteListInteractor)
@property (nonatomic, strong) id<ZIKTViperInteractor,ZIKTNoteListInteractorInput> interactor;
///是否登录
@property (nonatomic, assign) BOOL logined;
@end

@implementation ZIKTNoteListViewPresenter



/**
        基础事件（生命周期）
    ViewController/View 的视图之事件回调（生命周期延续)
         处理UI上面问题。（设计很不错，解O了）
 */
#pragma mark ZIKTViperViewEventHandler

- (void)handleViewReady {
    /**
             当视图开始时，路由器、Presenter、交互器都必须初始化完成
                            !!!!!增加断言让程序更清晰
     */
    NSAssert(self.wireframe, @"Router should be initlized when view is ready.");
    NSAssert([self.view conformsToProtocol:@protocol(ZIKTNoteListViewProtocol)], @"Presenter should be attach to a view.");
    NSAssert([self.interactor conformsToProtocol:@protocol(ZIKTNoteListInteractorInput)], @"Interactor should be initlized when view is ready.");
    /// 交互器开始加载数据
    [self.interactor loadAllNotes];
}

- (void)handleViewWillAppear:(BOOL)animated {
    
}

- (void)handleViewDidAppear:(BOOL)animated {
    ///没登录，线框图会调用弹出进行登录
    if (self.logined == NO) {
        [self.wireframe presentLoginViewWithMessage:@"Login in to use this app" delegate:self completion:nil];
    }
}

- (void)handleViewWillDisappear:(BOOL)animated {
    
}

- (void)handleViewDidDisappear:(BOOL)animated {
    
}

- (void)handleViewRemoved {
    
}

- (void)didTouchNavigationBarAddButton {
    /// 弹出编辑控制器
    [self.wireframe presentEditorForCreatingNewNoteWithDelegate:self completion:nil];
}

/**
     viewController/View的数据源处理地方，(数据生成地)
                    处理数据上面问题（设计很不错，解O了）
 */
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

/**
       具体View上面的事件（非生命周期）
   ViewController/View 的视图之事件回调 
        处理UI上面问题。（设计很不错，解O了）
*/
#pragma mark ZIKTNoteListViewEventHandler

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)handleDeleteCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.interactor deleteNoteAtIndex:indexPath.row];
}

- (void)handleDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *uuid = [self.interactor noteUUIDAtIndex:indexPath.row];
    NSString *title = [self.interactor noteTitleAtIndex:indexPath.row];
    NSString *content = [self.interactor noteContentAtIndex:indexPath.row];
    
    [self.wireframe pushEditorViewForEditingNoteWithUUID:uuid title:title content:content delegate:self];
}

#pragma mark ZIKTLoginViewDelegate

- (void)loginViewController:(UIViewController *)loginViewController didLoginWithAccount:(NSString *)account {
    self.logined = YES;
    [self.wireframe dismissLoginView:loginViewController animated:YES completion:nil];
}

#pragma mark ZIKTEditorDelegate

- (void)editor:(UIViewController *)editor didFinishEditNote:(ZIKTNoteModel *)note {
    [self.wireframe quitEditorViewWithAnimated:YES];
    [self.view.noteListTableView reloadData];
}

#pragma mark UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    __block UIViewController *destinationViewController;
    NSIndexPath *indexPath = [self.view.noteListTableView indexPathForRowAtPoint:location];
    
    NSString *uuid = [self.interactor noteUUIDAtIndex:indexPath.row];
    NSString *title = [self.interactor noteTitleAtIndex:indexPath.row];
    NSString *content = [self.interactor noteContentAtIndex:indexPath.row];
    destinationViewController = [self.wireframe editorViewForEditingNoteWithUUID:uuid title:title content:content delegate:self];
    NSAssert(destinationViewController != nil, nil);
    return destinationViewController;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.wireframe pushEditorViewController:viewControllerToCommit fromViewController:self.view.routeSource animated:YES];
}

@end
