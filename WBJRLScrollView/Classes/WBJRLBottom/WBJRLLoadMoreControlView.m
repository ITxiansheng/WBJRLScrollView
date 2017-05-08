//
//  WBJLoadMoreControlView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "WBJRLLoadMoreControlView.h"
#import "WBJRLLoadMoreView.h"
#import "UIScrollView+ContentExtension.h"

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
//KVO监测的scrollView属性
static NSString * const WBJOffsetKeyPath      = @"contentOffset";
static NSString * const WBJContentSizeKeyPath = @"contentSize";

//KVO监测的ViewModel属性
static NSString *  const  WBJLoadMoreStateKeyPath = @"loadMoreState";

@interface  WBJRLLoadMoreControlView ()

@property (nonatomic,strong) UIView <WBJRLLoadMoreAnimation>* loadMoreView;
@property (nonatomic,weak) UIScrollView * observerView;

@end

@implementation WBJRLLoadMoreControlView

- (instancetype) init{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self addSubview:self.loadMoreView];
        _loadMoreView.userInteractionEnabled = NO;
        _noLoadMoreLessScreen = YES;
        _hideLoadMoreControllView = NO;
        _loadMoreHeight = 0.0f;
        [self initViewModelKVO];
        [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


//被点击
- (void) clicked:(id) sender {
    if((self.loadMoreState==WBJLoadMoreStateIdle || self.loadMoreState==WBJLoadMoreStateError)){
        //发出UIControlEventValueChanged事件,触发对应的 selector（外部设置）
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self setLoadMoreState:WBJLoadMoreStateLoading];
    }
}

//当子view添加到父view上或者从父view上移除，调用此方法
- (void) willMoveToSuperview:(UIScrollView *)newSuperview {
    //移除父view观察者
    [self.superview removeObserver:self forKeyPath:WBJOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:WBJContentSizeKeyPath];
    //添加到父view上
    if(newSuperview) {
        NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"父View 必须是ScrollView 或者其子类");
        //对新的父view进行观察
        [newSuperview addObserver:self forKeyPath:WBJOffsetKeyPath
                          options:NSKeyValueObservingOptionNew context:nil];
        
        [newSuperview addObserver:self forKeyPath:WBJContentSizeKeyPath
                          options:NSKeyValueObservingOptionNew context:nil];
        self.observerView = newSuperview;
        self.observerView.clipsToBounds = YES;
        //添加到scrollview时，scrollview的contentsize此时为0
        self.observerView.ld_contentInsertBottom += [self getLoadMoreHeight];
    }
    //从父view上移除
    else{
        self.observerView.ld_contentInsertBottom -= [self getLoadMoreHeight];
    }
    [super willMoveToSuperview:newSuperview];
}

//重写setter，设置scrollView的contentInset.bottom
- (void) setHidden:(BOOL)hidden {
    //设置完 bottom会直接跳转到 contentsize kvo方法中
    if(!hidden&&super.hidden){
        [super setHidden:hidden];
        self.observerView.ld_contentInsertBottom += [self getLoadMoreHeight];
    }
    else if(hidden&&!super.hidden){
        [super setHidden:hidden];
        self.observerView.ld_contentInsertBottom -= [self getLoadMoreHeight];
    }
}

#pragma mark - private
//内容是否满一屏幕
- (BOOL)contentIsFullBounds{

    return (self.observerView.contentSize.height > CGRectGetHeight(self.observerView.bounds));
}

- (void)initViewModelKVO {
    
    [self addObserver:self forKeyPath:WBJLoadMoreStateKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setViewBy:(WBJLoadMoreState) loadMoreState{
    switch (loadMoreState) {
        case WBJLoadMoreStateNone:
            self.hidden = YES;
            if ([self.loadMoreView respondsToSelector:@selector(setHiddenStyle)]) {
                [self.loadMoreView setHiddenStyle];
            }
            break;
        case WBJLoadMoreStateNoMore:
            self.hidden = NO;
            [self.loadMoreView setNoMoreStyle];
            break;
        case WBJLoadMoreStateError:
            self.hidden = NO;
            [self.loadMoreView setErrorStyle];
            break;
        case WBJLoadMoreStateIdle:
            self.hidden = NO;
            [self.loadMoreView setIdleStyle];
            break;
        case WBJLoadMoreStateLoading:
            self.hidden = NO;
            [self.loadMoreView setLoadingStyle];
            break;
        default:
            break;
    }
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //监测scrollView的contentOffset变化
    if([keyPath isEqualToString:WBJOffsetKeyPath]) {
        if(!(self.isHidden||self.alpha < 0.01)&&(self.loadMoreState==WBJLoadMoreStateIdle)) {
            //scrollView的contentsize的高度不为0，并且滑出LoadMore时，触发Action
            if(self.observerView.contentSize.height != 0 && self.observerView.ld_contentOffsetTop + self.observerView.bounds.size.height - self.observerView.contentSize.height > 0) {
                //发出UIControlEventTouchUpInside事件,触发对应的 selector（clicked:）
                [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        return ;
    }
    //监测scrollView的contentSize变化, 调整self的frame
    if([keyPath isEqualToString:WBJContentSizeKeyPath]) {
        CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
        CGFloat height = (fequal(contentSize.height,0.0f)) ? 0.0f :[self getLoadMoreHeight];
        //默认设置且不满一屏幕时特殊处理
        if (self.noLoadMoreLessScreen && ![self contentIsFullBounds]) {
            self.frame = CGRectMake(0, contentSize.height, contentSize.width,0);
            self.hidden = YES;
        }else{
            if (!self.hideLoadMoreControllView) {
                self.frame = CGRectMake(0, contentSize.height, contentSize.width,height);
                self.hidden = NO;
            }
        }
        return;
    }
    //监测ViewModel的WBJLoadMoreState,设置显示
    if([keyPath isEqualToString:WBJLoadMoreStateKeyPath]) {
        WBJLoadMoreState  loadMoreState = [(NSNumber *)[change objectForKey:@"new"] integerValue];
        [self setViewBy:loadMoreState];
        return ;
    }
}



- (void)dealloc {
    
    [self removeObserver:self forKeyPath:WBJLoadMoreStateKeyPath];
}

#pragma mark - getter

- (CGFloat)getLoadMoreHeight {
    
    if (fequal(_loadMoreHeight, 0.0f)) {
        _loadMoreHeight = [WBJRLScrollViewConfig shareInstance].globalLoadMoreHeight;
    }
    return _loadMoreHeight;
}

- (UIView <WBJRLLoadMoreAnimation> *)loadMoreView {
    
    if (!_loadMoreView) {
        self.loadMoreAnimationType = [WBJRLScrollViewConfig shareInstance].globalLoadMoreAnimationType;
    }
    return _loadMoreView;
    
}

- (UIView *)displayView {
    return _loadMoreView;
}

#pragma mark - setter

- (void)setLoadMoreAnimationType:(WBJRLLoadMoreAnimationType)loadMoreAnimationType{
    
    if (_loadMoreAnimationType == loadMoreAnimationType) {
        return;
    }
    if (_loadMoreView) {
        [_loadMoreView removeFromSuperview];
        _loadMoreView = nil;
    }
    switch (loadMoreAnimationType) {
        case WBJRLLoadMoreAnimationDefault: {
            UIView <WBJRLLoadMoreAnimation> * loadMoreView = [[WBJRLLoadMoreView alloc] initWithFrame:CGRectZero];
            _loadMoreView = loadMoreView;
        }
            break;
        default:
            break;
    }
    _loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _loadMoreAnimationType = loadMoreAnimationType;
}

- (void)setLoadMoreHeight:(CGFloat)loadMoreHeight {
    
    if (fequal(_loadMoreHeight, loadMoreHeight)||self.hideLoadMoreControllView) {
        return;
    }
    self.frame = CGRectMake(0, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame),loadMoreHeight);
    //保存loadmore自身以外的高度
    self.observerView.ld_contentInsertBottom = self.observerView.ld_contentInsertBottom - _loadMoreHeight +loadMoreHeight;
    _loadMoreHeight = loadMoreHeight;
}

- (void)setNoMoreText:(NSString *)noMoreText
{
    _noMoreText = noMoreText;
    [self.loadMoreView setNoMoreDescText:noMoreText];
}

@end
