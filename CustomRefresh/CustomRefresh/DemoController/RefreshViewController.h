//
//  RefreshViewController.h
//  CustomRefresh
//
//  Created by Apple on 2017/1/4.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshViewController : UIViewController

/**
 *  是否自动加载更多，默认上拉超过scrollView的内容高度时，直接加载更多
 */
@property (unsafe_unretained, nonatomic) BOOL autoLoadMore;

@end
