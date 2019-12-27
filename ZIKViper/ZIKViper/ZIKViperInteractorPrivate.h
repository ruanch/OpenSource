//
//  ZIKViperInteractorPrivate.h
//  ZIKViper
//
//  Created by zuik on 2017/7/17.
//  Copyright © 2017 zuik. All rights reserved.
//

#import "ZIKViperInteractor.h"

///私有化getter/setter的方法，只能在Interactor中使用。
@protocol ZIKViperInteractorPrivate <ZIKViperInteractor>
- (void)setEventHandler:(id)eventHandler;
- (void)setDataSource:(id)dataSource;
@end
