//
//  RefreshViewController.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//
//https://www.testhnmgjr.com/mgjr-web-app/V2.0/appHqb/tenderingList?code=161019161528239685&keyStr=b9921fc51a4d1ec2997b0c1378559212&pageNum=1&pageSize=500
#import "RefreshViewController.h"
#import "MGRefreshFootView.h"
#import "MGRefreshHeaderView.h"
#import "UIScrollView+MGRefresh.h"
#import "NetworkTool.h"
#import "NSDictionary+SafeObject.h"

@interface RefreshViewController ()<UITableViewDelegate,UITableViewDataSource,NetworkDelegate>
@property (assign, nonatomic) NSInteger rows;
@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) MGRefreshHeaderView *headerView;
@property (strong, nonatomic) MGRefreshFootView *footerView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NetworkTool *networkTool;
@property (nonatomic , assign) int  pageNum;
@property (nonatomic , assign) int  pageSize;
@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"上下拉刷新";
    
    _networkTool = [[NetworkTool alloc] init];
    _networkTool.delegate = self;
    
    self.rows = 12;
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    self.mTableView.delegate   = self;
    self.mTableView.dataSource = self;
    self.mTableView.rowHeight  = 60;
    [self.view addSubview:self.mTableView];
    [self addRefreshView];
//    [self setTableViewData];
    
}

- (void)getDateDetail {
    _pageNum = 1;
    _pageSize = 30;
    NSDictionary *pageNumDic = @{@"pageNum":@(_pageNum)};
    NSDictionary *pageSizeDic = @{@"pageSize":@(_pageSize)};
    NSDictionary *codeDictionary = @{@"code":@"161019161528239685"};
    NSArray *array = @[codeDictionary,pageNumDic,pageSizeDic];
    [_networkTool getWithURLString:@"appJmg/tenderingList" parameters:array unParameters:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //进入页面就刷新
    [self.mTableView.refreshHeaderView startRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
//    __weak UITableView *weakTableView = self.mTableView;
    __weak MGRefreshHeaderView *weakHeaderView = self.mTableView.refreshHeaderView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.rows = 20;
//        [weakTableView reloadData];

        [self getDateDetail];
        [weakHeaderView endRefresh];
    });
}

- (void)loadMoreAction {
//    __weak UITableView *weakTableView = self.mTableView;
    __weak MGRefreshFootView *weakFooterView = self.mTableView.refreshFootView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.rows += 20;
//        [weakTableView reloadData];

        _pageNum ++;
        _pageSize = 30;
        NSDictionary *pageNumDic = @{@"pageNum":@(_pageNum)};
        NSDictionary *pageSizeDic = @{@"pageSize":@(_pageSize)};
        NSDictionary *codeDictionary = @{@"code":@"161019161528239685"};
        NSArray *array = @[codeDictionary,pageNumDic,pageSizeDic];
        [_networkTool getWithURLString:@"appJmg/tenderingList" parameters:array unParameters:nil];
        [weakFooterView endRefresh];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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

#pragma mark NetWorkDelegate
- (void)requestStart:(NetworkTool*)networkTool {
    
}
- (void)request:(NetworkTool*)networkTool didReceiveData:(NSDictionary*)data
{
    if ([[data safeObjectForKey:@"status"] isEqualToString:@"0000"]) {
        if ([data checkObjectExit:@"tenderList"]) {
            [_dataArray addObjectsFromArray:[data objectForKey:@"tenderList"]];
        }
        [_mTableView reloadData];
    }
}

- (void)request:(NetworkTool*)networkTool didReceiveError:(NSString*)error {
    
}


@end


