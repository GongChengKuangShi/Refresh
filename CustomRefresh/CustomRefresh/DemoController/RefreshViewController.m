//
//  RefreshViewController.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "RefreshViewController.h"
#import "MGRefreshFootView.h"
#import "MGRefreshHeaderView.h"
#import "UIScrollView+MGRefresh.h"

@interface RefreshViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) NSInteger rows;
@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) MGRefreshHeaderView *headerView;
@property (strong, nonatomic) MGRefreshFootView *footerView;

@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"上下拉刷新";
    
    self.rows = 12;
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    self.mTableView.delegate   = self;
    self.mTableView.dataSource = self;
    self.mTableView.rowHeight  = 60;
    [self.view addSubview:self.mTableView];
    
    [self addRefreshView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //进入页面就刷新
    [self.mTableView.refreshHeaderView startRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)addRefreshView {
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    self.mTableView.refreshHeaderView = [self.mTableView addHeaderWithRefreshHandler:^(MGRefreshBaseView *refreshBaseView) {
        [weakSelf refreshAction];
    }];
    
    //下拉刷新
    self.mTableView.refreshFootView = [self.mTableView addFooterWithRefreshHandler:^(MGRefreshBaseView *refreshBaseView) {
        [weakSelf loadMoreAction];
    }];
    
    //自动刷新
    self.footerView.autoLoadMore = self.autoLoadMore;
}

- (void)refreshAction {
    __weak UITableView *weakTableView = self.mTableView;
    __weak MGRefreshHeaderView *weakHeaderView = self.mTableView.refreshHeaderView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rows = 12;
        [weakTableView reloadData];
        [weakHeaderView endRefresh];
    });
}

- (void)loadMoreAction {
    __weak UITableView *weakTableView = self.mTableView;
    __weak MGRefreshFootView *weakFooterView = self.mTableView.refreshFootView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rows += 12;
        [weakTableView reloadData];
        [weakFooterView endRefresh];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    return cell;
}


@end


