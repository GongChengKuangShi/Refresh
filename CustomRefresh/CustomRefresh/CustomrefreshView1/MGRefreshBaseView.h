//
//  MGRefreshBaseView.h
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MGRefreshState) {
    MGRefreshStateNormal     = 1,
    MGRefreshStatePulling    = 2,
    MGRefreshStateLoading    = 3,
    MGRefreshStateNoMoreData = 4  //上拉加载显示没有更多数据
};

typedef NS_ENUM(NSInteger, MGRefreshViewType) {
    MGRefreshViewTypeHeader = -1,
    MGRefreshViewTypeFooter = 1
};

// 刷新偏移量的高度
static const CGFloat MGRefreshLoadingOffsetHeight = 60;
//文本颜色
#define FCXREFRESHTEXTCOLOR [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]

@class MGRefreshBaseView;
typedef void(^MGRefreshHandler)(MGRefreshBaseView *refreshBaseView);

@interface MGRefreshBaseView : UIView

//UI
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIImageView *arrowImage;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (assign, nonatomic) UIEdgeInsets originalEdgeInset;

//other
@property (weak, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) MGRefreshHandler  refreshHandler;
@property (unsafe_unretained, nonatomic) MGRefreshState refreshState;
@property (nonatomic, copy) NSString *normalStateText;//正常状态文本
@property (nonatomic, copy) NSString *pullingStateText;//下拉状态提示文本
@property (nonatomic, copy) NSString *loadingStateText;//加载中的提示文本
@property (nonatomic, copy) NSString *noMoreDataStateText;//没有更多数据提示文本



- (void)setStateText;//设置各种状态的文本

/**
 *  添加刷新的界面
 *
 *  注：如果想自定义刷新加载界面，可在子类中重写该方法进行布局子界面
 */
- (void)addRefreshContentView;

//开始刷新
- (void)startRefresh;
//结束刷新
- (void)endRefresh;
// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange;
// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange;


@end
