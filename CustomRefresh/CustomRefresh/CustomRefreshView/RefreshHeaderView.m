//
//  RefreshHeaderView.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "RefreshHeaderView.h"

typedef NS_ENUM(NSInteger, RefreshState) {
    RefreshStateNormal  = 1,
    RefreshStatePulling = 2,
    RefreshStateLoading = 3,
};

typedef void (^RefreshedHandler)(void);

const CGFloat RefreshHeaderHeight = 60;

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor   [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont    [UIFont systemFontOfSize:12.0f]

@interface RefreshHeaderView ()
//UI
@property (strong, nonatomic) UIScrollView            *scrollView;
@property (strong, nonatomic) UILabel                 *statusLabel;
@property (strong, nonatomic) UIImageView             *arrowImageView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

//Data
@property (assign, nonatomic) UIEdgeInsets             initEdgeInset;
@property (strong, nonatomic) NSDictionary             *stateTextDic;
@property (assign, nonatomic) CGFloat                  dragHeightThreshold;
@property (copy, nonatomic) RefreshedHandler           refreshedHandler;
@property (assign, nonatomic) RefreshState             refreshState;
@end

@implementation RefreshHeaderView

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)init {
    if (self = [super init]) {
        [self drawrefreshView];
        [self initData];
    }
    return self;
}

- (void)drawrefreshView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, -RefreshHeaderHeight, ScreenWidth, RefreshHeaderHeight);
    self.statusLabel = ({
        UILabel *lab        = [[UILabel alloc] init];
        lab.frame           = CGRectMake(0, 0, ScreenWidth, RefreshHeaderHeight);
        lab.font            = TextFont;
        lab.textColor       = TextColor;
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:lab];
        
        lab;
    });
    
    self.arrowImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_pull_refresh"]];
        imageView.frame        = CGRectMake(ScreenWidth/2.0 - 60,(RefreshHeaderHeight-32)/2.0, 32, 32);
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
    self.stateTextDic = @{@"normalText" : @"下拉刷新",
                          @"pullingText" : @"释放更新",
                          @"loadingText" : @"加载中"
                          };
    self.refreshState = RefreshStateNormal;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _initEdgeInset = scrollView.contentInset;
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:keyPath]) {
        [self scrollViewContentOffsetDidChange];
    }
}

- (void)scrollViewContentOffsetDidChange {
    if (self.dragHeight < 0 || self.refreshState == RefreshStateLoading) {
        return;
    }
    if (self.scrollView.isDragging) {
        if (self.dragHeight < self.dragHeightThreshold) {
            self.refreshState = RefreshStateNormal;
        } else {
            self.refreshState = RefreshStatePulling;
        }
    } else {
        if (self.refreshState == RefreshStatePulling) {
            self.refreshState = RefreshStateLoading;
        }
    }
}

- (CGFloat)dragHeight {
    return (self.scrollView.contentOffset.y + _initEdgeInset.top) * -1.0;
}

- (CGFloat)dragHeightThreshold {
    return RefreshHeaderHeight;
}

- (void)setRefreshState:(RefreshState)refreshState {
    _refreshState = refreshState;
    
    switch (_refreshState) {
        case RefreshStateNormal: {
            [self normalAnination];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentInset = _initEdgeInset;
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
                UIEdgeInsets inset           = _initEdgeInset;
                inset.top                   += RefreshHeaderHeight;
                self.scrollView.contentInset = _initEdgeInset;
            }];
            
            if (self.refreshedHandler) {
                self.refreshedHandler();
            }
            break;
        }
    }
}

- (void)normalAnination {
    _statusLabel.text      = self.stateTextDic[@"normalText"];
    
    _arrowImageView.hidden = NO;
    [_indicatorView stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)pullingAnimation {
    _statusLabel.text      = self.stateTextDic[@"pullingText"];
    
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)loadingAnimation {
    _statusLabel.text         = self.stateTextDic[@"loadingText"];
    
    _arrowImageView.hidden    = YES;
    _arrowImageView.transform = CGAffineTransformIdentity;
    [_indicatorView startAnimating];
}

- (void)startRefresh {
    self.refreshState = RefreshStateLoading;
}

- (void)endRefresh {
    self.refreshState = RefreshStateNormal;
}

@end
