//
//  GTViperRouter.h
//  GTViper
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTViperView;
@protocol GTViperPresenter;
@protocol GTViperInteractor;

@protocol GTViperRouter <NSObject>
- (void)assembleViper;
- (void)assembleViperForView:(id<GTViperView>)view
                   presenter:(id<GTViperPresenter>)presenter
                  interactor:(id<GTViperInteractor>)interactor;
@optional
@property (nonatomic, readonly, weak) id<GTViperPresenter> presenter;
@end
