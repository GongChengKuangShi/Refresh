//
//  ViewController.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "ViewController.h"
#import "WeiboRefreshDemoController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Refresh";
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64)];
    tableView.dataSource   = self;
    tableView.delegate     = self;
    [self.view addSubview:tableView];
    
    _dataArray = @[@"仿微博5.4.0上下拉加载"];
}

#pragma mark -- UITableViewDelegate and UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        WeiboRefreshDemoController *ctr = [[WeiboRefreshDemoController alloc] init];
        [self.navigationController  pushViewController:ctr animated:YES];
    }
}

@end
