//
//  WBJRLAnimationDelegate.h
//  Pods
//
//  Created by ITxiansheng on 2016/12/27.
//
//

#import <Foundation/Foundation.h>

@protocol WBJRLRefreshAnimation <NSObject>

@optional

/**
 *  下拉过程触发到临界点动画
 */
- (void)startTriggerAnimation;


/**
 *  "正在刷新"时的动画
 */
- (void)startLoadingAnimation;

/**
 *  停止"正在刷新"动画
 */
- (void)stopLoadingAnimation;

/*!
 *  @brief 处理ScrollView的偏移值
 *
 *  @param offset 偏移
 */
- (void)handleOffset:(CGPoint)offset;

@end
