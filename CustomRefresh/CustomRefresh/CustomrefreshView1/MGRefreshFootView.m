//
//  MGRefreshFootView.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "MGRefreshFootView.h"

@implementation MGRefreshFootView

@synthesize refreshState = _refreshState;

+ (instancetype)footerWithRefreshHandler:(MGRefreshHandler)refreshHandler {
    MGRefreshFootView *footer = [[MGRefreshFootView alloc] init];
    footer.refreshHandler = refreshHandler;
    return footer;
}

- (void)setStateText {
    self.normalStateText     = @"上拉加载更多...";
    self.pullingStateText    = @"松手后加载更多...";
    self.loadingStateText    = @"正在加载更多...";
    self.noMoreDataStateText = @"没有更多数据";
}

- (void)addRefreshContentView {
    [super addRefreshContentView];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //刷新状态
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.frame = CGRectMake(0, 0, screenWidth, MGRefreshLoadingOffsetHeight);
    self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.statusLabel.textColor = FCXREFRESHTEXTCOLOR;
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.statusLabel];
    
    //箭头图片
    self.arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]];
    self.arrowImage.frame = CGRectMake(screenWidth/2.0 - 100, 12.5, 15, 40);
    [self addSubview:self.arrowImage];
    
    //转圈动画
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.frame = self.arrowImage.frame;
    [self addSubview:self.arrowImage];
}

- (void)setAutoLoadMore:(BOOL)autoLoadMore {
    _autoLoadMore = autoLoadMore;
    if (_autoLoadMore) {//自动加载更多不显示箭头
        [self.arrowImage removeFromSuperview];
        self.arrowImage = nil;
        self.normalStateText  = @"正在加载更多...";
        self.pullingStateText = @"正在加载更多...";
        self.loadingStateText = @"正在加载更多...";
    }
}

- (void)scrollViewContentSizeDidChange {
    CGRect frame = self.frame;
    frame.origin.y = MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.frame = frame;
}

- (void)scrollViewContentOffsetDidChange {
    
    if (self.refreshState == MGRefreshStateNoMoreData) {
        return;
    }
    
    if (self.autoLoadMore) {//如果是自动加载更多
        if ([self exceedScrollViewContentSizeHeight] > 1) {//大于偏移量1，转为加载更多loading
            self.refreshState = MGRefreshStateLoading;
        }
        return;
    }
    
    if (self.scrollView.isDragging) {
        if ([self exceedScrollViewContentSizeHeight] > MGRefreshLoadingOffsetHeight) { // 大于偏移量， 转为pulling
            self.refreshState = MGRefreshStatePulling;
        } else {
            self.refreshState = MGRefreshStateNormal;
        }
    } else {
        if (self.refreshState == MGRefreshStatePulling) {//如果是pulling状态，就转化为loading状态
            self.refreshState = MGRefreshStateLoading;
        } else if ([self exceedScrollViewContentSizeHeight] < MGRefreshLoadingOffsetHeight) {// 小于偏移量，转化为正常状态
            self.refreshState = MGRefreshStateNormal;
        }
    }
}

- (CGFloat)exceedScrollViewContentSizeHeight {
    
    //获取scrollView实际显示内容高度
    CGFloat actualShowHeight = self.scrollView.frame.size.height - self.originalEdgeInset.bottom - self.originalEdgeInset.top;
    return self.scrollView.contentOffset.y - (self.scrollView.contentSize.height - actualShowHeight);
}

- (void)setRefreshState:(MGRefreshState)refreshState {
    
    MGRefreshState lastRefreshState = _refreshState;
    
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        
        __weak __typeof(self)weakSelf = self;
        
        switch (refreshState) {
            case MGRefreshStateNormal: {
                self.statusLabel.text = self.normalStateText;
                if (lastRefreshState == MGRefreshStateLoading) {//之前是刷新过
                    self.arrowImage.hidden = YES;
                } else {
                    self.arrowImage.hidden = NO;
                }
                self.arrowImage.hidden = NO;
                
                [self.activityView stopAnimating];
                
                [UIView animateWithDuration:0.2 animations:^{
                   self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                    weakSelf.scrollView.contentInset = self.originalEdgeInset;
                }];
            }
                
                break;
            
            case MGRefreshStatePulling : {
                self.statusLabel.text = self.pullingStateText;
                [UIView animateWithDuration:0.2 animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
                break;
                
            case MGRefreshStateLoading : {
                self.statusLabel.text = self.loadingStateText;
                [self.activityView startAnimating];
                self.arrowImage.hidden = YES;
                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                
                [UIView animateWithDuration:0.2 animations:^{
                   
                    UIEdgeInsets inset = weakSelf.scrollView.contentInset;
                    inset.bottom += MGRefreshLoadingOffsetHeight;
                    weakSelf.scrollView.contentInset = inset;
                    inset.bottom = self.frame.origin.y - weakSelf.scrollView.contentSize.height + MGRefreshLoadingOffsetHeight;
                    weakSelf.scrollView.contentInset = inset;
                }];
                
                if (self.refreshHandler) {
                    self.refreshHandler(self);
                }
            }
                break;
                
            case MGRefreshStateNoMoreData : {
                self.statusLabel.text = self.noMoreDataStateText;
            }
                break;
        }
    }
}

- (void)endRefresh {
    [self scrollViewContentSizeDidChange];
    [super endRefresh];
}

- (void)showNoMoreData {
    self.refreshState = MGRefreshStateNoMoreData;
}

- (void)resetNoMoreData {
    self.refreshState = MGRefreshStateNormal;
}

@end
