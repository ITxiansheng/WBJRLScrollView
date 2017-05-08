//
//  WBJRLScrollView.m
//  Pods
//
//  Created by ITxiansheng on 2016/12/26.
//
//

#import "WBJRLScrollView.h"

@implementation WBJRLScrollView
- (instancetype ) initWithFrame:(CGRect)frame  {
    
    self = [super initWithFrame:frame];
    if(self){
        WBJRLRefreshControllView * refreshControllView = [[WBJRLRefreshControllView alloc] initWithFrame:frame];
        self.refreshControllView = refreshControllView ;
        WBJRLLoadMoreControlView *loadMoreControllView = [[WBJRLLoadMoreControlView alloc] init];
        self.loadMoreControllView =loadMoreControllView;
        self.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf4/255.0 alpha:1.0];
    }
    return self;
}


@end
