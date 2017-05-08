//
//  WBJConfig.h
//  LDWBJPullToReload
//
//  Created by ITxiansheng on 2017/1/9.
//  Copyright © 2017年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBJConfig : NSObject

@property (nonatomic, strong)  NSArray *scrollTypes;
@property (nonatomic, strong)  NSArray *refreshTestTypes;
@property (nonatomic, strong)  NSArray *loadmoreTestTypes;

+ (instancetype)shareInstance ;

@end
