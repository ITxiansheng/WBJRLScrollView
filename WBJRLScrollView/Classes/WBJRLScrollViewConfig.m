//
//  WBJScrollViewConfig.m
//  Pods
//
//  Created by ITxiansheng on 2016/12/27.
//
//

#import "WBJRLScrollViewConfig.h"

@implementation WBJRLScrollViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _globalRefreshAnimationType = WBJRLRefreshAnimationCat;
        _globalRefreshHeight = 60.0f;
        _globalMiniAnimationTime = 0.0f;
        _globalLoadMoreAnimationType = WBJRLLoadMoreAnimationDefault;
        _globalLoadMoreHeight = 49.0f;
    }
    return self;
}

+ (instancetype)shareInstance
{
    static WBJRLScrollViewConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WBJRLScrollViewConfig alloc] init];
    });
    return instance;
}


@end
