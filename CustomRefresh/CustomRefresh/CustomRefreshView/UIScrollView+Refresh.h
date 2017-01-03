//
//  UIScrollView+Refresh.h
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefreshHeaderView;
@class RefreshFooterView;

typedef void (^RefreshedHandler)(void);

@interface UIScrollView (Refresh)

//header
@property (strong, nonatomic) RefreshHeaderView *reshHeaderView;
- (RefreshHeaderView *)addRefreshHeaderWithHandler:(RefreshedHandler)refreshHandler;
//For Header Extend
- (RefreshHeaderView *)addRefreshHeader:(RefreshHeaderView *)refreshHeaderView handler:(RefreshedHandler)refreshHandler;


//footer
@property (strong, nonatomic) RefreshFooterView *reshFooterView;
- (RefreshFooterView *)addRefreshFooterWithHandler:(RefreshedHandler)refreshHandler;
//For footer Extend
- (RefreshFooterView *)addRefreshFooter:(RefreshFooterView *)refreshFooterView handler:(RefreshedHandler)refreshHandler;

@end
