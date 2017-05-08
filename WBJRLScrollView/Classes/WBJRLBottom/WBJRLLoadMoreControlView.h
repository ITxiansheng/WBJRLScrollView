//
//  WBJLoadMoreControlView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//


/**
 *  WBJLoadMoreView 对应的viewModel ，负责数据的处理
 */
typedef NS_ENUM(NSInteger, WBJLoadMoreState){
    WBJLoadMoreStateNone,//隐藏加载更多
    WBJLoadMoreStateLoading,//正在加载更多
    WBJLoadMoreStateError,//加载更多错误状态
    WBJLoadMoreStateNoMore,//全部加载完毕
    WBJLoadMoreStateIdle,//空闲状态
};

#import "WBJRLScrollViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  加载更多view
 */
@interface WBJRLLoadMoreControlView : UIControl

/**
 *  加载更多状态，通过设置状态，改变view的展示
 */
@property (nonatomic,assign) WBJLoadMoreState loadMoreState;
@property (nonatomic,assign) BOOL noLoadMoreLessScreen;                 // 默认设置，控制内容不满一屏幕，隐藏 没有更多和加载错误 显示
@property (nonatomic,assign) BOOL hideLoadMoreControllView;             // 是否隐藏 上拉加载更多
@property (nonatomic, strong, readonly, nullable) UIView *displayView;  // 负责实际显示的loadMoreView
@property (nonatomic, assign) WBJRLLoadMoreAnimationType loadMoreAnimationType;

@property (nonatomic, assign)  CGFloat loadMoreHeight;

@property (nonatomic, strong) NSString *noMoreText;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
