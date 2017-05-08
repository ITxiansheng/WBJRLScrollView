//
//  UIScrollView+WBJRefresh.m
//  Pods
//
//  Created by ITxiansheng on 2016/12/26.
//
//

#import "UIScrollView+WBJRLRefreshLoadMore.h"
#import <objc/runtime.h>

@implementation UIScrollView (WBJRLRefreshLoadMore)

static char const *const WBJRefreshControllViewKey = "WBJRefreshControllViewKey";
static char const *const WBJRefrshBlockKey = "WBJRefrshBlockKey";

static char const *const WBJLoadMoreControllViewKey = "WBJLoadMoreControllViewKey";
static char const *const WBJLoadMoreBlockKey = "WBJLoadMoreBlockKey";

#pragma mark - setter

//===================下拉刷新 ================
//refreshControllView setter
- (void)setRefreshControllView:(WBJRLRefreshControllView *)refreshControllView {
    
    if (refreshControllView != self.refreshControllView) {
        // 删除旧的，添加新的
        [self.refreshControllView removeFromSuperview];
        [self addSubview:refreshControllView];
        
        objc_setAssociatedObject(self, &WBJRefreshControllViewKey,
                                 refreshControllView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

//refreshControllView Block setter
- (void)setRefreshBlock:(WBJNoneParameterBlock) refreshBlock {
    
        objc_setAssociatedObject(self, &WBJRefrshBlockKey,
                                 refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self.refreshControllView addTarget:self action:@selector(pullDownRefresh:) forControlEvents:UIControlEventValueChanged];
}

//miniAnimationTime setter

- (void)setMiniAnimationTime:(NSTimeInterval)miniAnimationTime {
    
    if (self.miniAnimationTime!=miniAnimationTime) {
        self.refreshControllView.miniAnimationTime = miniAnimationTime;
    }
}

//refreshAnimationType setter
- (void)setRefreshAnimationType:(WBJRLRefreshAnimationType)refreshAnimationType {
    
    if (self.refreshAnimationType!=refreshAnimationType) {
        //设置RefreshControllView的动画类型，会改变 下拉刷新动画。
        self.refreshControllView.refreshAnimationType = refreshAnimationType;
    }
}

//=================上拉加载更多==================
//loadMoreControllView setter
- (void)setLoadMoreControllView:(WBJRLLoadMoreControlView *)loadMoreControllView {
    
    if (loadMoreControllView != self.loadMoreControllView) {
        [self.loadMoreControllView removeFromSuperview];
        [self addSubview:loadMoreControllView];
        objc_setAssociatedObject(self, &WBJLoadMoreControllViewKey,
                                 loadMoreControllView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

//loadMoreControllView Block setter

- (void)setLoadMoreBlock:(WBJNoneParameterBlock)loadMoreBlock {
    
    if (self.loadMoreBlock!=loadMoreBlock) {
        objc_setAssociatedObject(self, &WBJLoadMoreBlockKey,
                                 loadMoreBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self.loadMoreControllView addTarget:self action:@selector(pullUpLoadMore:) forControlEvents:UIControlEventValueChanged];
    }
}

//refreshHeight setter
- (void)setRefreshHeight:(CGFloat)refreshHeight {
    
    if (self.refreshHeight!=refreshHeight) {
        self.refreshControllView.refreshHeight = refreshHeight;
    }
}

//loadMoreHeight setter
- (void)setLoadMoreHeight:(CGFloat)loadMoreHeight {
    
    if (self.loadMoreHeight!=loadMoreHeight) {
        self.loadMoreControllView.loadMoreHeight = loadMoreHeight;
    }
}

//loadMoreAnimationType setter
- (void)setLoadMoreAnimationType:(WBJRLLoadMoreAnimationType)loadMoreAnimationType {
    
    if (self.loadMoreAnimationType!=loadMoreAnimationType) {
        self.loadMoreControllView.loadMoreAnimationType = loadMoreAnimationType;
    }
}

//loadMoreState setter
- (void)setLoadMoreState:(WBJLoadMoreState)loadMoreState {
    
    if (self.loadMoreState!=loadMoreState) {
        self.loadMoreControllView.loadMoreState = loadMoreState;
    }
}

//noLoadMoreLessScreen setter
- (void)setNoLoadMoreLessScreen:(BOOL)noLoadMoreLessScreen {
    
    if (self.loadMoreControllView.noLoadMoreLessScreen!=noLoadMoreLessScreen) {
        self.loadMoreControllView.noLoadMoreLessScreen = noLoadMoreLessScreen;
    }
}

//hideLoadMoreControllView setter
- (void)setHideLoadMoreControllView:(BOOL)hideLoadMoreControllView {
    
    if (self.loadMoreControllView.hideLoadMoreControllView!=hideLoadMoreControllView) {
        self.loadMoreControllView.hidden = hideLoadMoreControllView;
        self.loadMoreControllView.hideLoadMoreControllView = hideLoadMoreControllView;
    }
}




#pragma mark - getter

//===================下拉刷新 ================

//refreshControllView getter

- (WBJRLRefreshControllView *)refreshControllView {
    
    return objc_getAssociatedObject(self, &WBJRefreshControllViewKey);
}

//refreshControllView Block getter

- (WBJNoneParameterBlock)refreshBlock {
    
    return objc_getAssociatedObject(self, &WBJRefrshBlockKey);
}

//loadMoreControllView getter
- (WBJRLLoadMoreControlView *)loadMoreControllView {
    
    return objc_getAssociatedObject(self, &WBJLoadMoreControllViewKey);
}

//loadMoreControllView Block getter

- (WBJNoneParameterBlock)loadMoreBlock {
    
    return objc_getAssociatedObject(self, &WBJLoadMoreBlockKey);
}

//refreshHeight getter

- (CGFloat )refreshHeight {
    
    return self.refreshControllView.refreshHeight;
}

//miniAnimationTime getter

- (NSTimeInterval)miniAnimationTime {
    
    return self.refreshControllView.miniAnimationTime;
}

//refreshAnimationType getter

- (WBJRLRefreshAnimationType)refreshAnimationType {
    
   return self.refreshControllView.refreshAnimationType;
}

//refreshHeight getter

- (CGFloat )loadMoreHeight {
    
    return self.loadMoreControllView.loadMoreHeight;
}

//loadMoreAnimationType getter

- (WBJRLLoadMoreAnimationType)loadMoreAnimationType {
    
    return self.loadMoreControllView.loadMoreAnimationType;
}

//hideLoadMoreControllView getter

- (BOOL)hideLoadMoreControllView {
    
    return self.loadMoreControllView.hideLoadMoreControllView;
}

//loadMoreState getter

- (WBJLoadMoreState)loadMoreState {
    
    return self.loadMoreControllView.loadMoreState;
}

//noLoadMoreLessScreen getter

- (BOOL)noLoadMoreLessScreen {
    
    return self.loadMoreControllView.noLoadMoreLessScreen;
}


#pragma mark - action

- (void) pullDownRefresh:(id)sender {
    
    if(self.refreshBlock){
        self.refreshBlock();
    }
}

- (void) pullUpLoadMore:(id)sender {
    
    if(self.loadMoreBlock){
        self.loadMoreBlock();
    }
}

#pragma mark - public method


- (void) beginRefreshAnimated:(BOOL)animated{
    
    [self.refreshControllView beginRefreshAnimated:animated];
}

- (void) endRefreshAnimated:(BOOL)animated{
    
    [self.refreshControllView endRefreshAnimated:animated];
}

@end
