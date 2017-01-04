//
//  MGRefreshFootView.h
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "MGRefreshBaseView.h"

@interface MGRefreshFootView : MGRefreshBaseView

//是否加载更多，默认上拉超过scrollView的内容高度时，直接加载更多
@property (unsafe_unretained, nonatomic) BOOL autoLoadMore;

+ (instancetype)footerWithRefreshHandler:(MGRefreshHandler)refreshHandler;

//显示没有更多数据
- (void)showNoMoreData;

//重置没有更多的数据
- (void)resetNoMoreData;

@end
