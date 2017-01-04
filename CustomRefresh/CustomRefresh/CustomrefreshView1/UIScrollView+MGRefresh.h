//
//  UIScrollView+MGRefresh.h
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRefreshBaseView.h"

@class MGRefreshHeaderView;
@class MGRefreshFootView;

@interface UIScrollView (MGRefresh)

@property (strong, nonatomic) MGRefreshHeaderView *refreshHeaderView;
@property (strong, nonatomic) MGRefreshFootView   *refreshFootView;
- (MGRefreshHeaderView *)addHeaderWithRefreshHandler:(MGRefreshHandler)refreshHandler;
- (MGRefreshFootView *)addFooterWithRefreshHandler:(MGRefreshHandler)refreshHandler;

@end
