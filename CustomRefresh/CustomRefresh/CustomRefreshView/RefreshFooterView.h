//
//  RefreshFooterView.h
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat RefreshFooterHeight;

@interface RefreshFooterView : UIView
@property (assign, nonatomic) BOOL autoLoadMore;//default YES
@property (assign, nonatomic) BOOL loadMoreEnabled;//default YES
@property (assign, nonatomic) CGFloat dragHeight;

- (void)endRefresh;
@end
