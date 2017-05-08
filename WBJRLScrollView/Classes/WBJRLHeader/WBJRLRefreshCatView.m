 //
//  WBJWBJRefreshView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "WBJRLRefreshCatView.h"
#import "UIImage+WBJPullToReloadBundle.h"
@interface WBJRLRefreshCatView ()

@property (nonatomic, strong) UIImageView  *catImgView;
@property (nonatomic, copy) NSArray *loadingCats;
@property (nonatomic, copy) NSArray *rollOverCats;
@property (nonatomic, assign) BOOL isRollOverAnimating;
@property (nonatomic, assign) BOOL isLoadingAnimating;
@property (nonatomic, strong) NSLayoutConstraint  *imageViewHeightConstrain;

@end

@implementation WBJRLRefreshCatView

#pragma mark - life style


- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        [self initSubviews];
        [self initConstraints];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark Private Method

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.catImgView];
}

- (void)initConstraints {
    
    //x轴居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.catImgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    //底部相距-8
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.catImgView
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeBottom
                         multiplier:1.0
                         constant:-8]];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}
#pragma mark - protocol

- (void)startTriggerAnimation {
    
    if (self.isRollOverAnimating) {
        return;
    }
    self.isRollOverAnimating = YES;
    self.isLoadingAnimating = NO;
    self.catImgView.image = [UIImage imageNamed:@"ldcat_4"];;
    self.catImgView.animationDuration = 0.3f;
    self.catImgView.animationRepeatCount = 1;
    self.catImgView.contentMode =UIViewContentModeCenter;
    self.catImgView.animationImages = self.rollOverCats;
    [self.catImgView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startLoadingAnimation];
    });
}

- (void)startLoadingAnimation {
    
    if (self.isLoadingAnimating) {
        return;
    }
    self.isLoadingAnimating = YES;
    self.catImgView.animationDuration = 0.6f;
    self.catImgView.animationRepeatCount = 0;
    self.catImgView.contentMode =UIViewContentModeCenter;
    self.catImgView.animationImages = self.loadingCats;
    [self.catImgView startAnimating];
}

- (void)stopLoadingAnimation {
    self.isRollOverAnimating = NO;
    self.isLoadingAnimating = NO;
    [self.catImgView stopAnimating];
    self.catImgView.animationImages = nil;
    self.catImgView.contentMode = UIViewContentModeScaleToFill;
    self.catImgView.image = [UIImage imageNamed:@"wbjcircle"];
}

- (void)handleOffset:(CGPoint)offset {
    
    if (offset.y <= -60 || offset.y >= 0) {
        return;
    }
    [self stopLoadingAnimation];
    if (self.imageViewHeightConstrain) {
        [self removeConstraint:self.imageViewHeightConstrain];
    }
    self.imageViewHeightConstrain =[NSLayoutConstraint constraintWithItem:self.catImgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(-offset.y)/60*40];
    [self addConstraint:self.imageViewHeightConstrain];
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

#pragma mark -getter

- (UIImageView *)catImgView {
    
    if (!_catImgView) {
        _catImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ldcircle"]];
        _catImgView.contentMode = UIViewContentModeScaleToFill;
        _catImgView.userInteractionEnabled = YES;
        _catImgView.translatesAutoresizingMaskIntoConstraints = NO;
        _catImgView.animationImages = self.rollOverCats;
    }
    return _catImgView;
}


- (NSArray *)loadingCats {
    
    if (!_loadingCats) {
        NSMutableArray *ma = [NSMutableArray array];
        for (int i = 4; i < 12; i++) {
            UIImage *image = [UIImage pullToReload_imageNamed:[NSString stringWithFormat:@"wbjcat_%d", i]];
            [ma addObject:image];
            _loadingCats = [NSArray arrayWithArray:ma];
        }
    }
    return _loadingCats;
}

- (NSArray *)rollOverCats {
    
    if (!_rollOverCats) {
        NSMutableArray *ma = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            UIImage *image = [UIImage pullToReload_imageNamed:[NSString stringWithFormat:@"wbjcat_%d", i]];
            [ma addObject:image];
            _rollOverCats = [NSArray arrayWithArray:ma];
        }
    }
    return _rollOverCats;

}



@end
