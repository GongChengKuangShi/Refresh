//
//  WeiboRefreshDemoController.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "WeiboRefreshDemoController.h"
#import "RefreshHeaderView.h"
#import "RefreshFooterView.h"
#import "UIScrollView+Refresh.h"

@interface WeiboRefreshDemoController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger data;

@end

@implementation WeiboRefreshDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self. automaticallyAdjustsScrollViewInsets =  YES;
    }
    
    self.title = @"微博5.4.0";
    _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64)];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    [self.view addSubview:_tableView];
    
    _data = 100;
    [self addRefreshView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView.reshHeaderView startRefresh];
}

- (void)addRefreshView {
    __weak __typeof(self) weakSelf = self;
    
    //下拉刷新
    _tableView.reshHeaderView = [_tableView addRefreshHeaderWithHandler:^{
        [weakSelf refreshData];
    }];
    
    //上拉加载更多
    _tableView.reshFooterView = [_tableView addRefreshFooterWithHandler:^{
        [weakSelf loadMoreData];
    }];
}

- (void)refreshData {
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _data = 20;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.reshHeaderView endRefresh];
        weakSelf.tableView.reshFooterView.loadMoreEnabled = YES;
    });
}

- (void)loadMoreData {
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _data += 20;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.reshHeaderView endRefresh];
        weakSelf.tableView.reshFooterView.loadMoreEnabled = NO;
        
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

@end
