//
//  WBJRefreshControllView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "WBJRLRefreshControllView.h"
#import "WBJRLRefreshCatView.h"
#import "UIScrollView+ContentExtension.h"
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

//KVO监测scrollview的contentOffset
static NSString * const WBJContentOffsetKeyPath = @"contentOffset";
//KVO监测scrollview的contentSize
static NSString * const WBJContentSizeKeyPath = @"contentSize";
//KVO监测的手势
static NSString * const WBJPanStateKeyPath    = @"state";
//KVO监测的viewModel属性
static NSString * const  refreshStatusKeyPath = @"refreshStatus";


@interface WBJRLRefreshControllView ()

@property (nonatomic, strong) UIView <WBJRLRefreshAnimation> *refreshView;
@property (nonatomic, weak) UIScrollView *observerView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSDate *animationBeginDate ;//动画开始时间

@end

@implementation WBJRLRefreshControllView


#pragma mark - life style

//设置frame 为CGRectZero，大小根据KVO观测值去设置
- (instancetype) initWithFrame:(CGRect)frame  {
    
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        [self addSubview:self.refreshView];
        [self initViewModelKVO];
        self.refreshStatus = WBJRefreshFinished;
        _refreshHeight= 0.0f;
        _miniAnimationTime = 0.0;
    }
    return self;
}

- (void) willMoveToSuperview:(UIScrollView *)newSuperview {
    //去除contentsize contentOffset  手势 的kvo
    [self.superview removeObserver:self forKeyPath:WBJContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:WBJContentSizeKeyPath];
    [self.panGestureRecognizer removeObserver:self forKeyPath:WBJPanStateKeyPath context:nil];
    self.panGestureRecognizer = nil;
    
    if(newSuperview){
        NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"父View 必须是ScrollView 或者其子类");
        //添加contentsize contentOffset 手势  的kvo
        [newSuperview addObserver:self forKeyPath:WBJContentOffsetKeyPath
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [newSuperview addObserver:self forKeyPath:WBJContentSizeKeyPath
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [newSuperview.panGestureRecognizer addObserver:self forKeyPath:WBJPanStateKeyPath
                                               options:NSKeyValueObservingOptionNew context:nil];
        self.panGestureRecognizer = newSuperview.panGestureRecognizer;
        self.observerView = newSuperview;
        self.observerView.clipsToBounds =YES;
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:refreshStatusKeyPath];
}

#pragma mark - private


- (void)initViewModelKVO {
    
    [self addObserver:self forKeyPath:refreshStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)finishAnimated:(BOOL)animated {
    
    if (animated) {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^ {
                             if (self.observerView.ld_contentOffsetTop < 0) {
                                 self.observerView.ld_contentOffsetTop = 0;
                             }
                         } completion:^(BOOL finished) {
                             
                         }];
    }else {
        if (self.observerView.ld_contentOffsetTop < 0) {
            self.observerView.ld_contentOffsetTop = 0;
        }
    }
    self.refreshStatus =WBJRefreshFinished;
}

#pragma mark - public

- (void) beginRefreshAnimated:(BOOL)animated {
    
    if (self.refreshStatus == WBJRefreshLoading) {
        return;
    }
    if (animated) {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.4
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^ {
                             self.observerView.ld_contentOffsetTop = -[self getRreshHeight];
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else {
        self.observerView.ld_contentOffsetTop = - [self getRreshHeight];
    }
    self.refreshStatus = WBJRefreshLoading;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)endRefreshAnimated:(BOOL)animated {
    
    if(self.refreshStatus == WBJRefreshFinished){
        return;
    }
    NSTimeInterval time = self.miniAnimationTime - [[NSDate date]timeIntervalSinceDate:self.animationBeginDate];
    if (time-0.0f>DBL_EPSILON) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self finishAnimated:animated];
        });
    } else {
        [self finishAnimated:animated];
    }
}

- (void) setRefreshStatus:(WBJRefreshStatus)refreshStatus {
    
    if(self.refreshStatus == refreshStatus){
        return;
    }
    if(refreshStatus == WBJRefreshLoading) {
        self.observerView.ld_contentInsertTop = [self getRreshHeight];
    }
    else {
        self.observerView.ld_contentInsertTop = 0;
    }
    _refreshStatus= refreshStatus;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.isHidden||self.alpha < 0.01) {
        return;
    }
    if(self.refreshStatus != WBJRefreshLoading) {
        //监控手势停止
        if([keyPath isEqualToString:WBJPanStateKeyPath]) {
            UIPanGestureRecognizer * panGestureRecognizer = object;
            if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
                if(-self.observerView.contentOffset.y > self.bounds.size.height){
                    [self setRefreshStatus:WBJRefreshLoading];
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }else {
                    [self setRefreshStatus:WBJRefreshFinished];
                }
            }
        }
        //Y轴偏移量变化
        else if([keyPath isEqualToString:WBJContentOffsetKeyPath]) {
            CGPoint offset = [[change objectForKey:@"new"] CGPointValue];
            CGFloat offsetY = offset.y;
            if ([self.refreshView respondsToSelector:@selector(handleOffset:)]) {
                [self.refreshView handleOffset:offset];
            }
            //触发临界点
            if (- offsetY >= [self getRreshHeight]){
                self.refreshStatus = WBJRefreshTrigered;
            }
        }
    }
    
    //监测contentsize设置frame
    if([keyPath isEqualToString:WBJContentSizeKeyPath]) {
        CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
        self.frame = CGRectMake(0, -[self getRreshHeight], contentSize.width,[self getRreshHeight]);
    }
    
    if([keyPath isEqualToString:refreshStatusKeyPath]) {
        WBJRefreshStatus status = [[change objectForKey:@"new"] integerValue];
        switch (status) {
            case WBJRefreshTrigered:
                if([self.refreshView respondsToSelector:@selector(startTriggerAnimation)]){
                    [self.refreshView startTriggerAnimation];
                }
                break;
            case WBJRefreshLoading:
                if([self.refreshView respondsToSelector:@selector(startLoadingAnimation)]){
                    [self.refreshView startLoadingAnimation];
                }
                self.animationBeginDate = [NSDate date];
                break;
            case WBJRefreshFinished:
                if([self.refreshView respondsToSelector:@selector(stopLoadingAnimation)]){
                    [self.refreshView stopLoadingAnimation];
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark - getter

-(UIView <WBJRLRefreshAnimation> *)refreshView {
    
    if (!_refreshView) {
        self.refreshAnimationType = [WBJRLScrollViewConfig shareInstance].globalRefreshAnimationType;
    }
    return _refreshView;
}

- (CGFloat)getRreshHeight {
    
    if (fequal(_refreshHeight, 0.0f)) {
        _refreshHeight =[WBJRLScrollViewConfig shareInstance].globalRefreshHeight;
    }
    return _refreshHeight;
}

- (NSTimeInterval)miniAnimationTime {
    
    if (fequal(_miniAnimationTime, [WBJRLScrollViewConfig shareInstance].globalMiniAnimationTime) ) {
        return [WBJRLScrollViewConfig shareInstance].globalMiniAnimationTime;
    }else {
        return _miniAnimationTime;
    }
}

- (UIView *)displayView {
    return _refreshView;
}

#pragma mark - setter
//设置 动画类型 时，会自动设置新的下拉 刷新动画
- (void)setRefreshAnimationType:(WBJRLRefreshAnimationType)refreshAnimationType {
    
    if (_refreshAnimationType == refreshAnimationType ) {
        return;
    }
    if (_refreshView) {
        [_refreshView removeFromSuperview];
        _refreshView = nil;
    }
    switch (refreshAnimationType) {
        case WBJRLRefreshAnimationCat: {
            UIView <WBJRLRefreshAnimation> * refreshView = [[WBJRLRefreshCatView alloc] initWithFrame:self.bounds];
            _refreshView = refreshView;
        }
            break;
        default:
            break;
    }
    if (_refreshView) {
        //重复添加同一个 子view 没有问题
        [self addSubview:_refreshView];
        _refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    _refreshAnimationType = refreshAnimationType;
}

- (void)setRefreshHeight:(CGFloat)refreshHeight {
    
    if (fequal(_refreshHeight, refreshHeight)) {
        return;
    }
    _refreshHeight = refreshHeight;
    self.frame = CGRectMake(0, -refreshHeight, CGRectGetWidth(self.bounds),refreshHeight);
}

@end
