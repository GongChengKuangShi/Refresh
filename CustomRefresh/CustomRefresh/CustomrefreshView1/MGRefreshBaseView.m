//
//  MGRefreshBaseView.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "MGRefreshBaseView.h"

@implementation MGRefreshBaseView

- (void)removeFromSuperview {
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setStateText];
        [self addRefreshContentView];
        self.refreshState = MGRefreshStateNormal;
    }
    return self;
}

- (void)addRefreshContentView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(0, - MGRefreshLoadingOffsetHeight, screenWidth, MGRefreshLoadingOffsetHeight);
    self.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self];
}

- (void)setStateText {
    
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _originalEdgeInset = scrollView.contentInset;
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
        
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //正在刷新
    if (self.refreshState == MGRefreshStateLoading) {
        return;
    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange];
    }
}

- (void)scrollViewContentOffsetDidChange {
    
}

- (void)scrollViewContentSizeDidChange {
    
}

- (void)startRefresh {
//    self.refreshState = MGRefreshStateLoading;
}

- (void)endRefresh {
    self.refreshState = MGRefreshStateNormal;
}
@end
