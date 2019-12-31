//
//  GTNewsListPresenter.m
//  GTViperDemo
//
//  Created by rch on 2019/12/17.
//  Copyright © 2019 nightelf. All rights reserved.
//

#import "GTNewsListPresenter.h"
#import "GTNewsListViewProtocol.h"


@interface GTNewsListPresenter()

@property(nonatomic,weak) id<GTViperView,GTNewsListViewProtocol> view;
 
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
    return 1;
}
- (NSString *)textOfCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"123";
}
-(NSString *)detailTextOfCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"content";
}



#pragma mark UIViewControllerPreviewingDelegate
- (void)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext commitViewController:(nonnull UIViewController *)viewControllerToCommit {
    
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
 
    return nil;
}

 
@end
