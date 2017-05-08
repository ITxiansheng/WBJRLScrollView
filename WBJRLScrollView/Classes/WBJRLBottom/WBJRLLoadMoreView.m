//
//  WBJWBJLoadMoreView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "WBJRLLoadMoreView.h"
#import "WBJRLLoadMoreView.h"
#import "UIImage+WBJPullToReloadBundle.h"
@interface WBJRLLoadMoreView ()

@property (nonatomic , strong)UIView *containerView;

@property (nonatomic,strong)  UILabel                 *labelMore;// 加载状态Label
@property (nonatomic, strong) WBJRLLoadMoreImageView	         *smileImageview; // 笑脸
@property (nonatomic, strong) WBJRLLoadMoreImageView	         *errorImageView; // 叉号
@property (nonatomic, strong) WBJRLRotationActivityIndicatorView *indicatorView;  // 加载
@property (nonatomic, strong) NSString *noMoreText;  //加载完成文案

@end

@implementation WBJRLLoadMoreView

- (instancetype) init {
    
    return  [self initWithFrame:CGRectZero];
}

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        [self initSubviews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - view private

- (void) initSubviews {
    
    self.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf4/255.0 alpha:1.0];
    self.clipsToBounds = YES;
    [self.containerView addSubview:self.smileImageview];
    [self.containerView addSubview:self.errorImageView];
    [self.containerView addSubview:self.indicatorView];
    [self.containerView addSubview:self.labelMore];
    [self addSubview:self.containerView];
}

- (void) layoutViews {
    
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_containerView,_smileImageview,_errorImageView,_indicatorView,_labelMore);
    
    //containerView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerView]|" options:0 metrics:nil views:viewDic]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    //smileImageview
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_smileImageview][_labelMore]|" options:0 metrics:nil views:viewDic]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.smileImageview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    //errorImageView
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_errorImageView][_labelMore]|" options:0 metrics:nil views:viewDic]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    //indicatorView
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_indicatorView][_labelMore]|" options:0 metrics:nil views:viewDic]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    //labelMore
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelMore attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
}

#pragma mark - view getter

- (WBJRLRotationActivityIndicatorView *)indicatorView {
    
    if(!_indicatorView){
        _indicatorView = [[WBJRLRotationActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _indicatorView.hidden = YES;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicatorView;
}

- (UILabel *)labelMore {
    
    if(!_labelMore) {
        _labelMore                      = [[UILabel alloc] init];
        _labelMore.font                 = [UIFont systemFontOfSize:12];
        _labelMore.textColor            = [UIColor colorWithRed:0x8e/255.0 green:0x8e/255.0 blue:0x8e/255.0 alpha:1.0];
        _labelMore.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labelMore;
}

- (WBJRLLoadMoreImageView *)smileImageview {
    
    if (!_smileImageview) {
        _smileImageview = [[WBJRLLoadMoreImageView alloc]initWithImage:[self smileImage]];
        _smileImageview.contentMode = UIViewContentModeScaleAspectFit;
        _smileImageview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _smileImageview;
}

- (WBJRLLoadMoreImageView *)errorImageView {
    
    if (!_errorImageView) {
        _errorImageView = [[WBJRLLoadMoreImageView alloc]initWithImage:[self errorImage]];
        _errorImageView.contentMode = UIViewContentModeScaleAspectFit;
        _errorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _errorImageView;
}

- (UIView *)containerView {
    
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

#pragma mark - property getter

- (NSString *)noMoreText
{
    if (!_noMoreText) {
        _noMoreText = @"已经到底啦~";
    }
    return _noMoreText;
}

#pragma mark - private method
- (UIImage *)smileImage {
    
    return [UIImage pullToReload_imageNamed:@"smile_Face"];
}

- (UIImage *)errorImage {
    
    return [UIImage pullToReload_imageNamed:@"sad_Face"];
}

- (UIImage *)indicatorImage {
    
    return [self.indicatorView indicatorImage];
}

#pragma mark - protocol

- (void)setNoMoreStyle {
    
    [self.indicatorView stopAnimating];
    [self.indicatorView setImage:nil];
    [self.errorImageView setImage:nil];
    [self.smileImageview setImage:self.smileImage];
    self.labelMore.text = self.noMoreText;
}

- (void)setLoadingStyle {
    
    [self.indicatorView setImage:self.indicatorImage];
    [self.indicatorView startAnimating];
    [self.smileImageview setImage:nil];
    [self.errorImageView setImage:nil];
    self.labelMore.text = @"正在努力加载..";
}

- (void)setErrorStyle {
    
    [self.indicatorView stopAnimating];
    [self.indicatorView setImage:nil];
    [self.errorImageView setImage:self.errorImage];
    [self.smileImageview setImage:nil];
    self.labelMore.text = @"加载失败，请点击重试";
}

- (void)setIdleStyle {
    
    [self.indicatorView stopAnimating];
    [self.indicatorView setImage:nil];
    [self.smileImageview setImage:nil];
    [self.errorImageView setImage:nil];
    self.labelMore.text = @"上拉加载更多";
}

- (void)setHiddenStyle {
    
    [self.indicatorView stopAnimating];
    [self.indicatorView setImage:nil];
    [self.errorImageView setImage:nil];
    [self.smileImageview setImage:nil];
    self.labelMore.text = nil;
}

- (void)setNoMoreDescText:(NSString *)noMoreDescText {
    self.noMoreText = noMoreDescText;
}
@end
