//
//  WBJWBJRefreshControllView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import <UIKit/UIKit.h>
//下拉状态
typedef NS_ENUM(NSInteger, WBJRefreshStatus){
    WBJRefreshNone = 0,
    WBJRefreshTrigered	= 1,//下拉临界点触发
    WBJRefreshLoading = 2 ,//刷新过程中
    WBJRefreshFinished = 3 //加载完毕
};

#import "WBJRLScrollViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBJRLRefreshControllView : UIControl

@property (nonatomic, assign) WBJRefreshStatus refreshStatus;

@property (nonatomic, assign) WBJRLRefreshAnimationType refreshAnimationType;//实例的 下拉刷新类型， 会覆盖全局设置，如果不设置则为全局设置的类型。

@property (nonatomic, assign)  CGFloat refreshHeight;//实例的 refresh高度， 会覆盖全局设置，如果不设置则为全局设置的类型。

@property (nonatomic, assign)  NSTimeInterval miniAnimationTime;//实例的最小动画时间， 会覆盖全局设置，如果不设置则为全局设置的类型。

@property (nonatomic, strong, readonly, nullable) UIView *displayView;  // 负责实际显示的refreshView

/**
 *
 *  @brief 手动执行刷新的操作，可以指定在header下拉的过程中
      是否产生动画效果
 *
 *  @param animated 是否产生动画
 */
- (void)beginRefreshAnimated:(BOOL)animated;

/**
 *
 *  @brief 手动执行结束刷新,可以指定在header结束的时候是否产生动画
 *
 *  @param animated 是否产生动画
 */
- (void)endRefreshAnimated:(BOOL)animated;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER ;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
