//
//  RefreshFooterView.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "RefreshFooterView.h"
typedef NS_ENUM(NSInteger, RefreshState) {
    RefreshStateNormal  = 1,
    RefreshStatePulling = 2,
    RefreshStateLoading = 3,
};

typedef void (^RefreshedHandler)(void);

const CGFloat RefreshFooterHeight = 60;

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor   [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont    [UIFont systemFontOfSize:12.0f]

@interface RefreshFooterView ()
//UI
@property (strong, nonatomic) UIScrollView            *scrollView;
@property (strong, nonatomic) UILabel                 *statusLabel;
@property (strong, nonatomic) UIImageView             *arrowImageView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

//Data
@property (assign, nonatomic) UIEdgeInsets            initEdgeInsets;
@property (strong, nonatomic) NSDictionary            *stateTextDic;
@property (assign, nonatomic) CGFloat                 dragHeightThreshold;

@property (copy, nonatomic) RefreshedHandler          refreshHandler;
@property (assign, nonatomic) RefreshState            refreshState;

@end

@implementation RefreshFooterView

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype)init {
    if (self = [super init]) {
        [self drawRefreshView];
        
        [self initData];
    }
    return self;
}

- (void)drawRefreshView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, ScreenWidth, RefreshFooterHeight);
    
    self.statusLabel = ({
        UILabel *lab        = [[UILabel alloc] init];
        lab.frame           = CGRectMake(0, 0, ScreenWidth, RefreshFooterHeight);
        lab.font            = TextFont;
        lab.textColor       = TextColor;
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:lab];
        
        lab;
    });
    
    self.arrowImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_pull_refresh"]];
        imageView.frame        = CGRectMake(ScreenWidth/2.0 - 60,(RefreshFooterHeight-32)/2.0, 32, 32);
        [self addSubview:imageView];
        
        imageView;
    });
    
    self.indicatorView = ({
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.color                    = TextColor;
        indicatorView.frame                    = _arrowImageView.frame;
        [self addSubview:indicatorView];
        
        indicatorView;
    });
}

- (void)initData {
    _loadMoreEnabled = YES;
    _autoLoadMore = YES;
    
    self.stateTextDic = @{@"normalText" : @"加载中...",
                          @"pullingText" : @"加载中...",
                          @"loadingText" : @"加载中..."
                          };
    
    self.refreshState = RefreshStateNormal;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView    != scrollView) {
        _initEdgeInsets = scrollView.contentInset;
        _scrollView     = scrollView;
        [_scrollView addSubview:self];
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        //init
        [self refreshFootViewFrame];
    }
}

- (void)refreshFootViewFrame {
    CGRect frame   = self.frame;
    frame.origin.y = MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.frame     = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange];
    }
}

- (void)scrollViewContentOffsetDidChange {
    if (self.dragHeight < 0 || self.refreshState == RefreshStateLoading || !self.loadMoreEnabled) {
        return;
    }
    
    if (self.autoLoadMore) {
        if (self.dragHeight > 1) {
            self.refreshState = RefreshStateLoading;
        }
    }else {
        if (self.scrollView.isDragging) {
            if (self.dragHeight < self.dragHeightThreshold) {
                self.refreshState = RefreshStateNormal;
            }else {
                self.refreshState = RefreshStatePulling;
            }
        }else {
            if (self.refreshState == RefreshStatePulling) {
                self.refreshState = RefreshStateLoading;
            }
        }
    }
}

- (void)scrollViewContentSizeDidChange {
    [self refreshFootViewFrame];
}

- (CGFloat)dragHeight {
    CGFloat contentHeight   = self.scrollView.contentSize.height;
    CGFloat tableViewHeight = self.scrollView.bounds.size.height;
    CGFloat originY         = MAX(contentHeight, tableViewHeight);
    return self.scrollView.contentOffset.y + self.scrollView.bounds.size.height - originY - _initEdgeInsets.bottom;
}

- (CGFloat)dragHeightThreshold {
    return RefreshFooterHeight;
}

- (void)setRefreshState:(RefreshState)refreshState {
    _refreshState = refreshState;
    
    switch (_refreshState) {
        case RefreshStateNormal: {
            [self normalAnimation];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentInset = _initEdgeInsets;
            }];
            break;
        }
            
        case RefreshStatePulling: {
            [self pullingAnimation];
            break;
        }

        case RefreshStateLoading: {
            [self loadingAnimation];
            
            [UIView animateWithDuration:0.3 animations:^{
                UIEdgeInsets insets = self.scrollView.contentInset;
                insets.bottom      += RefreshFooterHeight;
                self.scrollView.contentInset = insets;
            }];
            if (self.refreshHandler) {
                self.refreshHandler();
            }
            break;
        }
    }
}

- (void)normalAnimation {
    _statusLabel.text      = self.stateTextDic[@"normalText"];
    
    _arrowImageView.hidden = NO;
    [_indicatorView stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)pullingAnimation {
    _statusLabel.text = self.stateTextDic[@"pullingText"];
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)loadingAnimation {
    _statusLabel.text      = self.stateTextDic[@"loadingText"];
    _arrowImageView.hidden = YES;
    _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    [_indicatorView startAnimating];
}

- (void)endRefresh {
    self.refreshState = RefreshStateNormal;
}

- (void)setAutoLoadMore:(BOOL)autoLoadMore {
    if (autoLoadMore != _autoLoadMore) {
        _autoLoadMore = autoLoadMore;
        if (_autoLoadMore) {
            //autoloadMore
            [_arrowImageView removeFromSuperview];
            _arrowImageView.image = nil;
            
            self.stateTextDic = @{@"normalText" : @"加载中...",
                                  @"pullingText" : @"加载中...",
                                  @"loadingText" : @"加载中..."
                                  };
        }else {
            _arrowImageView.image = [UIImage imageNamed:@"grayArrow"];
            [self addSubview:_arrowImageView];
            
            self.stateTextDic = @{@"normalText" : @"上拉加载",
                                  @"pullingText" : @"释放加载",
                                  @"loadingText" : @"加载中..."
                                  };
        }
    }
}

- (void)setLoadMoreEnabled:(BOOL)loadMoreEnabled {
    if (loadMoreEnabled != _loadMoreEnabled) {
        _loadMoreEnabled = loadMoreEnabled;
        
        if (_loadMoreEnabled) {
            [self removeFromSuperview];
            [self.scrollView addSubview:self];
        } else {
            [self removeFromSuperview];
        }
    }
}


@end
