//
//  GTViperInteractorPrivate.h
//  GTViper
//
//  Created by rch on 2019/12/17.
//  Copyright © 2017 nightelf. All rights reserved.
//

#import "GTViperInteractor.h"

///私有化getter/setter的方法，只能在Interactor中使用。
@protocol GTViperInteractorPrivate <GTViperInteractor>
- (void)setEventHandler:(id)eventHandler;
- (void)setDataSource:(id)dataSource;
@end
