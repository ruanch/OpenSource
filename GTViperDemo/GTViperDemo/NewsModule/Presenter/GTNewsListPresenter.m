//
//  GTNewsListPresenter.m
//  GTViperDemo
//
//  Created by rch on 2019/12/17.
//  Copyright © 2019 nightelf. All rights reserved.
//

#import "GTNewsListPresenter.h"
#import "GTNewsListViewProtocol.h"

#import "GTViperInteractor.h"
#import "GTNewsListInteractorInput.h"

@interface GTNewsListPresenter()

@property(nonatomic,weak) id<GTViperView,GTNewsListViewProtocol> view;
@property(nonatomic,strong) id<GTViperInteractor,GTNewsListInteractorInput> interactor;
 
@end


@implementation GTNewsListPresenter

#pragma mark GTViperViewEventHandle

-(void)handleViewReady
{
    //NSAssert([self.view conformsToProtocol:@protocol(GTNewsListViewProtocol)], @"Presenter 没实实现 view的协议");
    
}
- (void)handleViewWillAppear:(BOOL)animated
{
    
}
- (void)handleViewWillDisappear:(BOOL)animated
{
    
}

- (void)handleViewRemoved
{
    
}

#pragma mark GTViperViewDataSource
- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.interactor.newsCount;
}
- (NSString *)textOfCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.interactor titleForNewsAtIndex:indexPath.row];
}
-(NSString *)detailTextOfCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.interactor contentForNewsAtIndex:indexPath.row];
}



#pragma mark UIViewControllerPreviewingDelegate
- (void)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext commitViewController:(nonnull UIViewController *)viewControllerToCommit {
    
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
 
    return nil;
}

 
@end
