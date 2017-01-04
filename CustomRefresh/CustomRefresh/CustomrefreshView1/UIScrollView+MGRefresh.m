//
//  UIScrollView+MGRefresh.m
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "UIScrollView+MGRefresh.h"
#import "MGRefreshHeaderView.h"
#import "MGRefreshFootView.h"
#import <objc/runtime.h>

@implementation UIScrollView (MGRefresh)

static const char * RefreshHeaderViewKey = "RefreshHeaderViewKey";
static const char * RefreshFooterViewKey = "RefreshFooterViewKey";

- (void)setRefreshHeaderView:(MGRefreshHeaderView *)refreshHeaderView {
    
    if (refreshHeaderView != self.refreshHeaderView) {
        [self.refreshHeaderView removeFromSuperview];
        [self addSubview:refreshHeaderView];
        
        objc_setAssociatedObject(self, RefreshHeaderViewKey, refreshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setRefreshFootView:(MGRefreshFootView *)refreshFootView {
    
    if (refreshFootView != self.refreshFootView) {
        [self.refreshFootView removeFromSuperview];
        [self addSubview:refreshFootView];
        
        objc_setAssociatedObject(self, RefreshFooterViewKey, refreshFootView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (MGRefreshHeaderView *)refreshHeaderView {
    return objc_getAssociatedObject(self, RefreshHeaderViewKey);
}

- (MGRefreshFootView *)refreshFootView {
    return objc_getAssociatedObject(self, RefreshFooterViewKey);
}

- (MGRefreshHeaderView *)addHeaderWithRefreshHandler:(MGRefreshHandler)refreshHandler {
    MGRefreshHeaderView *header = [MGRefreshHeaderView headerWithRefreshHandler:refreshHandler];
    header.scrollView = self;
    return header;
}

- (MGRefreshFootView *)addFooterWithRefreshHandler:(MGRefreshHandler)refreshHandler {
    MGRefreshFootView *footer = [MGRefreshFootView footerWithRefreshHandler:refreshHandler];
    footer.scrollView = self;
    return footer;
}

@end
