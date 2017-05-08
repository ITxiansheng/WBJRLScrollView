//
//  UIScrollView+WBJRefresh.h
//  Pods
//
//  Created by ITxiansheng on 2016/12/26.
//
//

///=============================
// 作为UIScrollView的父类
///=============================

#import <UIKit/UIKit.h>
#import "WBJRLRefreshControllView.h"
#import "WBJRLLoadMoreControlView.h"
typedef void(^WBJNoneParameterBlock)();

@interface UIScrollView (WBJRLRefreshLoadMore)

/** 下拉刷新控件 */
@property (strong, nonatomic) WBJRLRefreshControllView *refreshControllView;
/** 下拉刷新block */
@property (nonatomic,copy) WBJNoneParameterBlock refreshBlock;

/** 上拉刷新控件 */
@property (strong, nonatomic) WBJRLLoadMoreControlView *loadMoreControllView;
/** 上拉刷新Block */
@property (nonatomic,copy) WBJNoneParameterBlock loadMoreBlock;

@property (nonatomic, assign) WBJRLRefreshAnimationType refreshAnimationType;//实例的 下拉刷新类型， 会覆盖全局设置，如果不设置则为全局设置的类型。

@property (nonatomic, assign)  CGFloat refreshHeight;//实例的 refresh高度， 会覆盖全局设置，如果不设置则为全局设置的类型。

@property (nonatomic, assign)  NSTimeInterval miniAnimationTime;//实例的refresh最小动画时间， 会覆盖全局设置，如果不设置则为全局设置的类型。

@property (nonatomic, assign)  CGFloat loadMoreHeight;//实例的 上拉加载更多高度， 会覆盖全局设置，如果不设置则为全局设置的类型。

@property (nonatomic, assign) WBJRLLoadMoreAnimationType loadMoreAnimationType;//实例的 上拉加载更多类型， 会覆盖全局设置，如果不设置则为全局设置的类型。


/**
 *  @brief 控制是否隐藏 加载更多view  默认是不隐藏的
 */
@property (nonatomic,assign) BOOL hideLoadMoreControllView;

//LoadMore的状态
@property (nonatomic,assign) WBJLoadMoreState loadMoreState;

//不满一屏幕是否隐藏 LoadMore，默认是隐藏的
@property (nonatomic,assign) BOOL noLoadMoreLessScreen;

/**
 *
 *  @brief 手动控制开始下拉刷新，并且可以指定刷新的过程中是否有动画
 *
 *  @param animated 是否展示动画
 */
- (void) beginRefreshAnimated:(BOOL)animated;


/**
 *
 *  @brief 手动控制结束下拉刷新，并且可以指定结束刷新的过程中是否有动画
 *
 *  @param animated 是否展示动画
 */
- (void) endRefreshAnimated:(BOOL)animated;

@end
