//
//  TestViewController.m
//  Masonry iOS Examples
//
//  Created by liuke on 2019/12/6.
//  Copyright © 2019 Jonas Budelmann. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 164, 80, 50);
    [btn setTitle:@"top" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor yellowColor];
    btn1.frame = CGRectMake(0, 264, 80, 50);
    [btn1 setTitle:@"bottom" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(bottomClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [self initView];
}
- (void)initView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.and.right.equalTo(self.view);
        
        make.top.equalTo(self.mas_topLayoutGuide);
        
    }];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}
- (void)topClick{

    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
//    [self updateViewConstraints];
}
- (void)bottomClick{
    
    [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:NO];
    // 手动触发updateViewConstraints
//    [self updateViewConstraints];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
