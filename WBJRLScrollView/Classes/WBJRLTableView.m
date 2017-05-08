//
//  WBJRJTableView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "WBJRLTableView.h"

@implementation WBJRLTableView

- (instancetype ) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
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
