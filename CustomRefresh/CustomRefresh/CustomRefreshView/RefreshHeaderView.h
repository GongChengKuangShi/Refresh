//
//  RefreshHeaderView.h
//  CustomRefresh
//
//  Created by Apple on 2017/1/3.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat RefreshHeaderHeight;

@interface RefreshHeaderView : UIView
@property (assign, nonatomic) CGFloat dragHeight;

- (void)startRefresh;
- (void)endRefresh;
@end
