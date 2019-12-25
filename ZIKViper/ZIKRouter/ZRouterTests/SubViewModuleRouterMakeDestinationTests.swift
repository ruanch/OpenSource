//
//  ViewModuleRouterMakeDestinationTests.swift
//  ZRouterTests
//
//  Created by zuik on 2018/4/28.
//  Copyright © 2018 zuik. All rights reserved.
//

import XCTest
import ZRouter

class SubviewModuleRouterMakeDestinationTests: XCTestCase {
    weak var router: ModuleViewRouter<BSubviewModuleInput>? {
        willSet {
            strongRouter = newValue
        }
    }
    private var strongRouter: ModuleViewRouter<BSubviewModuleInput>?
    var leaveTestExpectation: XCTestExpectation?
    
    func enterTest() {
        leaveTestExpectation = self.expectation(description: "Leave test")
    }
    
    func leaveTest() {
        strongRouter = nil
        leaveTestExpectation?.fulfill()
    }
    
    func handle(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    override func setUp() {
        super.setUp()
        TestRouteRegistry.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        XCTAssert(self.router == nil, "Test router is not released")
        TestConfig.routeShouldFail = false
    }
    
    func testMakeDestination() {
        XCTAssertTrue(Router.to(RoutableViewModule<BSubviewModuleInput>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableViewModule<BSubviewModuleInput>())
        XCTAssertNotNil(destination)
    }
    
    func testMakeDestinationWithPreparation() {
        XCTAssertTrue(Router.to(RoutableViewModule<BSubviewModuleInput>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableViewModule<BSubviewModuleInput>(), preparation: { (module) in
            module.title = "test title"
            module.makeDestinationCompletion({ (destination) in
                XCTAssert(destination.title == "test title")
            })
        })
        XCTAssertNotNil(destination is BSubviewInput)
    }
    
    func testMakeDestinationWithConfiguring() {
        let providerExpectation = self.expectation(description: "successHandler")
        let performerExpectation = self.expectation(description: "performerSuccessHandler")
        let completionHandlerExpectation = self.expectation(description: "completionHandler")
        XCTAssertTrue(Router.to(RoutableViewModule<BSubviewModuleInput>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableViewModule<BSubviewModuleInput>(), configuring: { (config, prepareModule) in
            prepareModule({ module in
                module.title = "test title"
                module.makeDestinationCompletion({ (destination) in
                    XCTAssert(destination.title == "test title")
                })
            })
            config.successHandler = { d in
                providerExpectation.fulfill()
            }
            config.performerSuccessHandler = { d in
                performerExpectation.fulfill()
            }
            config.errorHandler = { (action, error) in
                XCTAssert(false, "errorHandler should not be called")
            }
            config.performerErrorHandler = { (action, error) in
                XCTAssert(false, "performerErrorHandler should not be called")
            }
            config.completionHandler = { (success, destination, action, error) in
                XCTAssertTrue(success)
                XCTAssert(destination is BSubviewInput)
                completionHandlerExpectation.fulfill()
            }
        })
        XCTAssertNotNil(destination is BSubviewInput)
        waitForExpectations(timeout: 5, handler: { if let error = $0 {print(error)}})
    }
}
