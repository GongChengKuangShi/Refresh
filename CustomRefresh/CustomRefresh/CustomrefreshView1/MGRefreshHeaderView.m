//
//  MGRefreshHeaderView.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "MGRefreshHeaderView.h"

@implementation MGRefreshHeaderView

@synthesize refreshState = _refreshState;

+ (instancetype)headerWithRefreshHandler:(MGRefreshHandler)refreshHandler {
    MGRefreshHeaderView *header = [[MGRefreshHeaderView alloc] init];
    header.refreshHandler       = refreshHandler;
    return header;
}

- (void)setStateText {
    self.normalStateText  = @"下拉刷新";
    self.pullingStateText = @"释放刷新";
    self.loadingStateText = @"正在刷新...";
}

- (void)addRefreshContentView {
    [super addRefreshContentView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //刷新状态
    
    self.statusLabel                 = [[UILabel alloc] init];
    self.statusLabel.frame           = CGRectMake(0, 15, screenWidth, 20);
    self.statusLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.statusLabel.textColor       = FCXREFRESHTEXTCOLOR;
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:self.statusLabel];
    
    //更新时间
    self.timeLabel                 = [[UILabel alloc] init];
    self.timeLabel.frame           = CGRectMake(0, 35, screenWidth, 20);
    self.timeLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.timeLabel.textColor       = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
    
    //箭头图片
    self.arrowImage       = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]];
    self.arrowImage.frame = CGRectMake(screenWidth/2.0 - 100, (MGRefreshLoadingOffsetHeight - 40)/2.0 + 5, 15, 40);
    [self addSubview:self.arrowImage];
    
    //转圈动画
    self.activityView       = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.frame = self.arrowImage.frame;
    [self addSubview:self.activityView];
    
}

- (void)scrollViewContentOffsetDidChange {
    if (self.scrollView.isDragging) { //正在拖拽
        if (self.scrollView.contentOffset.y < - MGRefreshLoadingOffsetHeight) {
            
            self.refreshState = MGRefreshStatePulling;
            
        } else {// 小于偏移量，转为正常normal
            
            self.refreshState = MGRefreshStateNormal;
            
        }
    } else {
        if (self.refreshState == MGRefreshStatePulling) {//如果是pulling状态，改为刷新加载loading
            
            self.refreshState = MGRefreshStateLoading;
        } else if (self.scrollView.contentOffset.y > - MGRefreshLoadingOffsetHeight) { //如果小于偏移量，转为正常normal

            self.refreshState = MGRefreshStateNormal;
        }
    }
}

- (void)setRefreshState:(MGRefreshState)refreshState {
    MGRefreshState lastRefreshState = _refreshState;
    
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        
        __weak __typeof(self)weakSelf = self;
        
        switch (refreshState) {
            case MGRefreshStateNormal: {
                
                self.statusLabel.text = self.normalStateText;
                if (lastRefreshState == MGRefreshStateLoading) {//之前就在刷新
                    [self updateTimeLabelWithLastUpdateTime:[NSDate date]];
                }
                self.arrowImage.hidden = NO;
                [self.arrowImage stopAnimating];
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                    weakSelf.scrollView.contentInset = self.originalEdgeInset;
                }];
            }
                break;
                
            case MGRefreshStatePulling: {
                self.statusLabel.text = self.pullingStateText;
                [UIView animateWithDuration:0.2 animations:^{
                   self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
                break;
            
            case MGRefreshStateLoading: {
                
                self.statusLabel.text = self.loadingStateText;
                
                [self.activityView startAnimating];
                self.arrowImage.hidden = YES;
                self.arrowImage.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.2 animations:^{
                    UIEdgeInsets edgeInset = self.originalEdgeInset;
                    edgeInset.top += MGRefreshLoadingOffsetHeight;
                    weakSelf.scrollView.contentInset = edgeInset;
                }];
                
                if (self.refreshHandler) {
                    self.refreshHandler(self);
                }
            }
                break;
                
            case MGRefreshStateNoMoreData: {
                
            }
                break;
        }
    }
}

- (void)startRefresh {
    __weak __typeof(self)weakSelf = self;
    weakSelf.refreshState = MGRefreshStateLoading;
    
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake(0, - MGRefreshLoadingOffsetHeight);
    } completion:^(BOOL finished) {
        weakSelf.refreshState = MGRefreshStateLoading;
    }];
}

- (void)updateTimeLabelWithLastUpdateTime:(NSDate *)lastUpdateTime {
    if (!lastUpdateTime) {
        self.timeLabel.text =  @"最后更新：无记录";
        return;
    }
    
    //获取年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) {
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) {
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:lastUpdateTime];
    //显示日期
    self.timeLabel.text = [NSString stringWithFormat:@"最后更新:%@",time];
}

@end
