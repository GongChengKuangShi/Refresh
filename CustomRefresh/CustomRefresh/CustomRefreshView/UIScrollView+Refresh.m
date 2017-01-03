//
//  UIScrollView+Refresh.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "RefreshFooterView.h"
#import "RefreshHeaderView.h"
#import <objc/runtime.h>

@implementation UIScrollView (Refresh)

#pragma mark - refreshHeader
static const char * RefreshHeaderViewKey = "RefreshHeaderViewKey";

- (void)setReshHeaderView:(RefreshHeaderView *)reshHeaderView {
    if (reshHeaderView != self.reshHeaderView) {
        [self.reshHeaderView removeFromSuperview];
        [self addSubview:reshHeaderView];
        objc_setAssociatedObject(self, RefreshHeaderViewKey, reshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RefreshHeaderView *)reshHeaderView {
    return objc_getAssociatedObject(self, RefreshHeaderViewKey);
}

- (RefreshHeaderView *)addRefreshHeaderWithHandler:(RefreshedHandler)refreshHandler {
    return [self addRefreshHeader:[[RefreshHeaderView alloc] init] handler:refreshHandler];
}

- (RefreshHeaderView *)addRefreshHeader:(RefreshHeaderView *)refreshHeaderView handler:(RefreshedHandler)refreshHandler {
    [refreshHeaderView setValue:refreshHandler forKey:@"refreshedHandler"];
    [refreshHeaderView setValue:self forKey:@"scrollView"];
    return refreshHeaderView;
}

#pragma mark - refreshFooter 
static const char *RefreshFooterViewKey = "RefreshFooterViewKey";

- (void)setReshFooterView:(RefreshFooterView *)reshFooterView {
    if (reshFooterView != self.reshFooterView) {
        [self.reshFooterView removeFromSuperview];
        [self addSubview:reshFooterView];
        
        objc_setAssociatedObject(self, RefreshFooterViewKey, reshFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RefreshFooterView *)reshFooterView {
    return  objc_getAssociatedObject(self, RefreshFooterViewKey);
}

- (RefreshFooterView *)addRefreshFooterWithHandler:(RefreshedHandler)refreshHandler {
    return [self addRefreshFooter:[[RefreshFooterView alloc] init] handler:refreshHandler];
}

- (RefreshFooterView *)addRefreshFooter:(RefreshFooterView *)refreshFooterView handler:(RefreshedHandler)refreshHandler {
    [refreshFooterView setValue:refreshHandler forKey:@"refreshHandler"];
    [refreshFooterView setValue:self forKey:@"scrollView"];
    return refreshFooterView;
}

@end
