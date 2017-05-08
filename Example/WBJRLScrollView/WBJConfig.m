//
//  WBJConfig.m
//  LDWBJPullToReload
//
//  Created by ITxiansheng on 2017/1/9.
//  Copyright © 2017年 xuguoxing. All rights reserved.
//

#import "WBJConfig.h"

@implementation WBJConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollTypes =@[@"WBJRLScrollView",@"WBJRLTableView",@"WBJRLCollectionView"];
        _refreshTestTypes = @[@"招财猫"];
        _loadmoreTestTypes = @[@"默认类型"];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static WBJConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WBJConfig alloc] init];
    });
    return instance;
}
@end
