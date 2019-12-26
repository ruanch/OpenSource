//
//  ZIKNoteListViewPresenter
//  ZIKViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017 zuik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <ZIKViper/ZIKViperPresenter.h>
#import "ZIKNoteListViewEventHandler.h"
#import "ZIKNoteListViewDataSource.h"
/**
    去掉了线框图，直接用Router代替了Builder和wireframe
         该类是ViewController : EventHandle和DataSource  与 Interactor：EVentHandle和DataSource的实现者。
 在ZIKViewRouter+ZIKViper.m中assembleViperForView:(id<ZIKViperViewPrivate>)view presenter:  interactor: 实现了
 */
NS_ASSUME_NONNULL_BEGIN

@interface ZIKNoteListViewPresenter : NSObject <ZIKViperPresenter,ZIKNoteListViewEventHandler,ZIKNoteListViewDataSource>
@property (nonatomic, strong) id wireframe;///无用
@end

NS_ASSUME_NONNULL_END
