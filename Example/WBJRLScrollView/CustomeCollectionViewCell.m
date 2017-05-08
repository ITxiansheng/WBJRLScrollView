//
//  CustomeCollectionViewCell.m
//  LDWBJPullToReload
//
//  Created by ITxiansheng on 2017/1/9.
//  Copyright © 2017年 xuguoxing. All rights reserved.
//

#import "CustomeCollectionViewCell.h"

@implementation CustomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *backgrounView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        backgrounView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:backgrounView];
        
    }
    return self;
}
@end
