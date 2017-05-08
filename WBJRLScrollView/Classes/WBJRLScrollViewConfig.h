//
//  WBJRLScrollViewConfig.h
//  Pods
//
//  Created by ITxiansheng on 2016/12/27.
//
//

#import <UIKit/UIKit.h>
//下拉刷新类型
typedef NS_ENUM(NSInteger, WBJRLRefreshAnimationType) {
    WBJRLRefreshAnimationCat     = 1,
    WBJRLRefreshAnimationPoints     =2,
};
//上拉加载更多类型
typedef NS_ENUM(NSInteger, WBJRLLoadMoreAnimationType) {
    
    WBJRLLoadMoreAnimationDefault     = 1,
};

@interface WBJRLScrollViewConfig : NSObject

//====下拉刷新===
@property (nonatomic, assign) WBJRLRefreshAnimationType globalRefreshAnimationType;

@property (nonatomic, assign)  CGFloat globalRefreshHeight;

@property (nonatomic, assign)  NSTimeInterval globalMiniAnimationTime;

//====上拉加载更多===
@property (nonatomic, assign) WBJRLLoadMoreAnimationType globalLoadMoreAnimationType;

@property (nonatomic, assign)  CGFloat globalLoadMoreHeight;

+ (instancetype)shareInstance ;

@end
