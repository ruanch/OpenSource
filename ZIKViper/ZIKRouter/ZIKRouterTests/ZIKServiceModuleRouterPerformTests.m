//
//  ZIKServiceModuleRouterPerformTests.m
//  ZIKRouterTests
//
//  Created by zuik on 2018/4/19.
//  Copyright © 2018 zuik. All rights reserved.
//

#import "ZIKRouterTestCase.h"
@import ZIKRouter;
#import "AServiceModuleInput.h"
#import "TestConfig.h"

@interface ZIKServiceModuleRouterPerformTests : ZIKRouterTestCase

@end

@implementation ZIKServiceModuleRouterPerformTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    [super tearDown];
    
}

- (void)testPerformWithPrepareDestination {
    XCTestExpectation *expectation = [self expectationWithDescription:@"prepareDestination"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithConfiguring:^(ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull config) {
            config.title = @"test title";
            [config makeDestinationCompletion:^(id<AServiceInput> destination) {
                XCTAssert([destination.title isEqualToString:@"test title"]);
            }];
            config.prepareDestination = ^(id _Nonnull destination) {
                XCTAssertNotNil(destination);
                [expectation fulfill];
            };
            config.completionHandler = ^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
                self.destination = destination;
                XCTAssertTrue(success);
                [self handle:^{
                    [self leaveTest];
                }];
            };
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithSuccessCompletionHandler {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithConfiguring:^(ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull config) {
            config.title = @"test title";
            [config makeDestinationCompletion:^(id<AServiceInput> destination) {
                XCTAssert([destination.title isEqualToString:@"test title"]);
            }];
            config.completionHandler = ^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
                self.destination = destination;
                XCTAssertTrue(success);
                XCTAssertNil(error);
                [expectation fulfill];
                [self handle:^{
                    XCTAssert(self.router.state == ZIKRouterStateRouted);
                    [self leaveTest];
                }];
            };
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithErrorCompletionHandler {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    @autoreleasepool {
        TestConfig.routeShouldFail = YES;
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithConfiguring:^(ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull config) {
            config.title = @"test title";
            [config makeDestinationCompletion:^(id<AServiceInput> destination) {
                XCTAssert([destination.title isEqualToString:@"test title"]);
            }];
            config.completionHandler = ^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
                XCTAssertFalse(success);
                XCTAssertNotNil(error);
                [expectation fulfill];
                [self handle:^{
                    XCTAssert(self.router == nil || self.router.state == ZIKRouterStateUnrouted);
                    [self leaveTest];
                }];
            };
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithSuccessCompletion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithCompletion:^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
            self.destination = destination;
            XCTAssertTrue(success);
            XCTAssertNil(error);
            [expectation fulfill];
            [self handle:^{
                XCTAssert(self.router.state == ZIKRouterStateRouted);
                [self leaveTest];
            }];
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithErrorCompletion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    @autoreleasepool {
        TestConfig.routeShouldFail = YES;
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithCompletion:^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
            self.destination = destination;
            XCTAssertFalse(success);
            XCTAssertNotNil(error);
            [expectation fulfill];
            [self handle:^{
                XCTAssert(self.router == nil || self.router.state == ZIKRouterStateUnrouted);
                [self leaveTest];
            }];
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithPreparation {
    XCTestExpectation *expectation = [self expectationWithDescription:@"preparation"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithPreparation:^(id _Nonnull destination) {
            XCTAssert(destination);
            [expectation fulfill];
            [self handle:^{
                XCTAssert(self.router.state == ZIKRouterStateRouted);
                [self leaveTest];
            }];
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformRouteWithSuccessCompletion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    expectation.assertForOverFulfill = YES;
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithCompletion:^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
            XCTAssertTrue(success);
            XCTAssertNil(error);
            
            [self handle:^{
                XCTAssert(self.router.state == ZIKRouterStateRouted);
                [self.router performRouteWithCompletion:^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
                    self.destination = destination;
                    XCTAssert(self.router.state == ZIKRouterStateRouted);
                    XCTAssertTrue(success);
                    XCTAssertNil(error);
                    [expectation fulfill];
                    [self leaveTest];
                }];
            }];
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformRouteWithErrorCompletion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    expectation.assertForOverFulfill = YES;
    @autoreleasepool {
        TestConfig.routeShouldFail = NO;
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithCompletion:^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
            XCTAssertTrue(success);
            
            [self handle:^{
                XCTAssert(self.router.state == ZIKRouterStateRouted);
                TestConfig.routeShouldFail = YES;
                [self.router performRouteWithCompletion:^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
                    XCTAssert(self.router.state == ZIKRouterStateRouted);
                    XCTAssertFalse(success);
                    XCTAssertNotNil(error);
                    [expectation fulfill];
                    [self leaveTest];
                }];
            }];
            
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"successHandler"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithConfiguring:^(ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull config) {
            config.title = @"test title";
            [config makeDestinationCompletion:^(id<AServiceInput> destination) {
                XCTAssert([destination.title isEqualToString:@"test title"]);
            }];
            config.successHandler = ^(id  _Nonnull destination) {
                self.destination = destination;
                XCTAssertNotNil(destination);
                [expectation fulfill];
                [self handle:^{
                    XCTAssert(self.router.state == ZIKRouterStateRouted);
                    [self leaveTest];
                }];
            };
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithPerformerSuccess {
    XCTestExpectation *successHandlerExpectation = [self expectationWithDescription:@"successHandler"];
    successHandlerExpectation.expectedFulfillmentCount = 2;
    XCTestExpectation *performerSuccessHandlerExpectation = [self expectationWithDescription:@"performerSuccessHandler once"];
    performerSuccessHandlerExpectation.assertForOverFulfill = YES;
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithConfiguring:^(ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull config) {
            config.title = @"test title";
            [config makeDestinationCompletion:^(id<AServiceInput> destination) {
                XCTAssert([destination.title isEqualToString:@"test title"]);
            }];
            config.successHandler = ^(id  _Nonnull destination) {
                XCTAssertNotNil(destination);
                [successHandlerExpectation fulfill];
            };
            config.performerSuccessHandler = ^(id  _Nonnull destination) {
                self.destination = destination;
                XCTAssertNotNil(destination);
                [performerSuccessHandlerExpectation fulfill];
                
                [self handle:^{
                    XCTAssert(self.router.state == ZIKRouterStateRouted);
                    [self.router performRouteWithSuccessHandler:^(id  _Nonnull destination) {
                        XCTAssert(self.router.state == ZIKRouterStateRouted);
                        XCTAssertNotNil(destination);
                        [self leaveTest];
                    } errorHandler:^(ZIKRouteAction  _Nonnull routeAction, NSError * _Nonnull error) {
                        
                    }];
                }];
                
            };
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testPerformWithError {
    XCTestExpectation *providerErrorExpectation = [self expectationWithDescription:@"providerErrorHandler"];
    XCTestExpectation *performerErrorExpectation = [self expectationWithDescription:@"performerErrorHandler"];
    @autoreleasepool {
        TestConfig.routeShouldFail = YES;
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput) performWithConfiguring:^(ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull config) {
            config.successHandler = ^(id  _Nonnull destination) {
                XCTAssert(NO, @"successHandler should not be called");
            };
            config.performerSuccessHandler = ^(id  _Nonnull destination) {
                XCTAssert(NO, @"successHandler should not be called");
            };
            config.errorHandler = ^(ZIKRouteAction  _Nonnull routeAction, NSError * _Nonnull error) {
                XCTAssertNotNil(error);
                [providerErrorExpectation fulfill];
            };
            config.performerErrorHandler = ^(ZIKRouteAction  _Nonnull routeAction, NSError * _Nonnull error) {
                XCTAssertNotNil(error);
                [performerErrorExpectation fulfill];
                [self handle:^{
                    XCTAssert(self.router == nil || self.router.state == ZIKRouterStateUnrouted);
                    [self leaveTest];
                }];
            };
        }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

#pragma mark Strict

- (void)testStrictPerformWithPrepareDestination {
    XCTestExpectation *expectation = [self expectationWithDescription:@"prepareDestination"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput)
                       performWithStrictConfiguring:^(ZIKPerformRouteStrictConfiguration *config, ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull module) {
                           module.title = @"test title";
                           [module makeDestinationCompletion:^(id<AServiceInput> destination) {
                               XCTAssert([destination.title isEqualToString:@"test title"]);
                           }];
                           config.successHandler = ^(id  _Nonnull destination) {
                               self.destination = destination;
                               XCTAssertNotNil(destination);
                               [expectation fulfill];
                               [self handle:^{
                                   XCTAssert(self.router.state == ZIKRouterStateRouted);
                                   [self leaveTest];
                               }];
                               
                           };
                       }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testStrictPerformWithSuccessCompletionHandler {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput)
                       performWithStrictConfiguring:^(ZIKPerformRouteStrictConfiguration *config, ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull module) {
                           module.title = @"test title";
                           [module makeDestinationCompletion:^(id<AServiceInput> destination) {
                               XCTAssert([destination.title isEqualToString:@"test title"]);
                           }];
                           config.completionHandler = ^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
                               self.destination = destination;
                               XCTAssertTrue(success);
                               XCTAssertNil(error);
                               [expectation fulfill];
                               [self handle:^{
                                   XCTAssert(self.router.state == ZIKRouterStateRouted);
                                   [self leaveTest];
                               }];
                           };
                       }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testStrictPerformWithErrorCompletionHandler {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completionHandler"];
    @autoreleasepool {
        TestConfig.routeShouldFail = YES;
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput)
                       performWithStrictConfiguring:^(ZIKPerformRouteStrictConfiguration *config, ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull module) {
                           config.completionHandler = ^(BOOL success, id  _Nullable destination, ZIKRouteAction  _Nonnull routeAction, NSError * _Nullable error) {
                               XCTAssertFalse(success);
                               XCTAssertNotNil(error);
                               XCTAssert(self.router == nil || self.router.state == ZIKRouterStateUnrouted);
                               [expectation fulfill];
                               [self handle:^{
                                   [self leaveTest];
                               }];
                           };
                       }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testStrictPerformWithSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"successHandler"];
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput)
                       performWithStrictConfiguring:^(ZIKPerformRouteStrictConfiguration *config, ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull module) {
                           module.title = @"test title";
                           [module makeDestinationCompletion:^(id<AServiceInput> destination) {
                               XCTAssert([destination.title isEqualToString:@"test title"]);
                           }];
                           config.successHandler = ^(id  _Nonnull destination) {
                               self.destination = destination;
                               XCTAssertNotNil(destination);
                               [expectation fulfill];
                               [self handle:^{
                                   XCTAssert(self.router.state == ZIKRouterStateRouted);
                                   [self leaveTest];
                               }];
                           };
                       }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testStrictPerformWithPerformerSuccess {
    XCTestExpectation *successHandlerExpectation = [self expectationWithDescription:@"successHandler"];
    successHandlerExpectation.expectedFulfillmentCount = 2;
    XCTestExpectation *performerSuccessHandlerExpectation = [self expectationWithDescription:@"performerSuccessHandler once"];
    performerSuccessHandlerExpectation.assertForOverFulfill = YES;
    @autoreleasepool {
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput)
                       performWithStrictConfiguring:^(ZIKPerformRouteStrictConfiguration *config, ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull module) {
                           module.title = @"test title";
                           [module makeDestinationCompletion:^(id<AServiceInput> destination) {
                               XCTAssert([destination.title isEqualToString:@"test title"]);
                           }];
                           config.successHandler = ^(id  _Nonnull destination) {
                               XCTAssertNotNil(destination);
                               [successHandlerExpectation fulfill];
                           };
                           config.performerSuccessHandler = ^(id  _Nonnull destination) {
                               XCTAssertNotNil(destination);
                               [performerSuccessHandlerExpectation fulfill];
                               
                               [self handle:^{
                                   [self.router performRouteWithSuccessHandler:^(id  _Nonnull destination) {
                                       self.destination = destination;
                                       XCTAssert(self.router.state == ZIKRouterStateRouted);
                                       XCTAssertNotNil(destination);
                                       [self leaveTest];
                                   } errorHandler:^(ZIKRouteAction  _Nonnull routeAction, NSError * _Nonnull error) {
                                       
                                   }];
                               }];
                               
                           };
                       }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

- (void)testStrictPerformWithError {
    XCTestExpectation *providerErrorExpectation = [self expectationWithDescription:@"providerErrorHandler"];
    XCTestExpectation *performerErrorExpectation = [self expectationWithDescription:@"performerErrorHandler"];
    @autoreleasepool {
        TestConfig.routeShouldFail = YES;
        [self enterTest];
        self.router = [ZIKRouterToServiceModule(AServiceModuleInput)
                       performWithStrictConfiguring:^(ZIKPerformRouteStrictConfiguration *config, ZIKPerformRouteConfiguration<AServiceModuleInput> * _Nonnull module) {
                           config.successHandler = ^(id  _Nonnull destination) {
                               XCTAssert(NO, @"successHandler should not be called");
                           };
                           config.performerSuccessHandler = ^(id  _Nonnull destination) {
                               XCTAssert(NO, @"successHandler should not be called");
                           };
                           config.errorHandler = ^(ZIKRouteAction  _Nonnull routeAction, NSError * _Nonnull error) {
                               XCTAssertNotNil(error);
                               [providerErrorExpectation fulfill];
                           };
                           config.performerErrorHandler = ^(ZIKRouteAction  _Nonnull routeAction, NSError * _Nonnull error) {
                               XCTAssertNotNil(error);
                               [performerErrorExpectation fulfill];
                               [self handle:^{
                                   XCTAssert(self.router == nil || self.router.state == ZIKRouterStateUnrouted);
                                   [self leaveTest];
                               }];
                           };
                       }];
    }
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        !error? : NSLog(@"%@", error);
    }];
}

@end
