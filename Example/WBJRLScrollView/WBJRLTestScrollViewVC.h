//
//  WBJRLTestScrollViewVC.h
//  LDCPPullToReload
//
//  Created by ITxiansheng on 2017/1/9.
//  Copyright © 2017年 xuguoxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+WBJRLRefreshLoadMore.h"

@interface WBJRLTestScrollViewVC : UIViewController

- (instancetype)initWithScrollViewType:(NSString *)scrollViewType refreshAnimationType:(WBJRLRefreshAnimationType) refreshType loadMoreAnimationType:(WBJRLLoadMoreAnimationType) loadMoreType;

@end
