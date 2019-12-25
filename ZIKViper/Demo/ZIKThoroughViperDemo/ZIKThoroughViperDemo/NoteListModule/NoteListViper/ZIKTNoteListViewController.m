//
//  ZIKTNoteListViewController
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//



/**
  ViewController的职责：
        1.把各项内容抛给对应的对象去做比如：视图事件、视图数据源交给presenter进行处理
        2.引入ZIKTViper.UIViewController_ZIKTViperRouter 只是用ZIK_isRemoving方法，判断是否已不存在
        3.引入ZIKTViperViewPrivate私有协议的实现，eventHandler是必须定义，viewDataSource可选
                 4.ZIKTNoteListViewEventHandler具体事件回调 （!!!!!!!其实可以合在ViewController上面)
                 5.ZIKTNoteListViewDataSource具体数据源（!!!!!!其实可以合在ViewController上面)
 这里定义了ViewController需要的头文件
 */
#import "ZIKTNoteListViewController.h"
@import ZIKTViper.ZIKTViperViewPrivate;
@import ZIKTViper.UIViewController_ZIKTViperRouter;
#import "ZIKTNoteListViewEventHandler.h"
#import "ZIKTNoteListViewDataSource.h"

/**
    1.实现土私有方法ZIKTViperViewPrivate目的是定义事件源和数据源
         2.UITableViewDelegate，UITableViewDataSource。把ViewController看成视图
 */
@interface ZIKTNoteListViewController () <ZIKTViperViewPrivate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL appeared;///首次标志
@property (nonatomic, strong) id<ZIKTNoteListViewEventHandler> eventHandler;
@property (nonatomic, strong) id<ZIKTNoteListViewDataSource> viewDataSource;
@property (weak, nonatomic) IBOutlet UITableView *noteListTableView;
@end

@implementation ZIKTNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    ///设置自身代理
    self.noteListTableView.delegate = self;
    self.noteListTableView.dataSource = self;
}

/**
      注册路由
 */
- (UIViewController *)routeSource {
    return self;
}

/**
    1.初始化视图UI的逻辑
    Tip:这部可以抽成一个公共ViewController，事件源都是基类协议调用
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.appeared == NO) {
        NSAssert([self.eventHandler conformsToProtocol:@protocol(ZIKTNoteListViewEventHandler)], nil);
        
        //对当前view指定eventHandler代理
        [self registerForPreviewingWithDelegate:self.eventHandler sourceView:self.view];
        UIBarButtonItem *addNoteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self.eventHandler
                                                                                     action:@selector(didTouchNavigationBarAddButton)];
        self.navigationItem.rightBarButtonItem = addNoteItem;
        
        if ([self.eventHandler respondsToSelector:@selector(handleViewReady)]) {
            [self.eventHandler handleViewReady];
        }
        self.appeared = YES;
    }
    if ([self.eventHandler respondsToSelector:@selector(handleViewWillAppear:)]) {
        [self.eventHandler handleViewWillAppear:animated];
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.eventHandler respondsToSelector:@selector(handleViewDidAppear:)]) {
        [self.eventHandler handleViewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.eventHandler respondsToSelector:@selector(handleViewWillDisappear:)]) {
        [self.eventHandler handleViewWillDisappear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.eventHandler respondsToSelector:@selector(handleViewDidDisappear:)]) {
        [self.eventHandler handleViewDidDisappear:animated];
    }
    if (self.ZIK_isRemoving == YES) {
        if ([self.eventHandler respondsToSelector:@selector(handleViewRemoved)]) {
            [self.eventHandler handleViewRemoved];
        }
    }
}

/**
      返回Cell
             这部分可抽象一个TableViewController
 */
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                      text:(NSString *)text
                                detailText:(NSString *)detailText {
    UITableViewCell *cell = [self.noteListTableView dequeueReusableCellWithIdentifier:@"noteListCell" forIndexPath:indexPath];
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    return cell;
}


#pragma mark UITableViewDataSource
/**
    tableView数据源协议方法，具体由presenter来实现
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewDataSource numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.viewDataSource textOfCellForRowAtIndexPath:indexPath];
    NSString *detailText = [self.viewDataSource detailTextOfCellForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath
                                                   text:text
                                             detailText:detailText];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.eventHandler canEditRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.eventHandler handleDeleteCellForRowAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark UITableViewDelegate
/**
   tableView代理协议方法，具体由presenter来实现
*/
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                 [self.eventHandler handleDeleteCellForRowAtIndexPath:indexPath];
                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             }]
             ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self .eventHandler handleDidSelectRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
