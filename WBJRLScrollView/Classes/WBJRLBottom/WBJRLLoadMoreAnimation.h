//
//  WBJRLLoadMoreAnimation.h
//  Pods
//
//  Created by ITxiansheng on 2016/12/28.
//
//

#import <Foundation/Foundation.h>

@protocol WBJRLLoadMoreAnimation <NSObject>

@required

- (void)setNoMoreStyle;

- (void)setNoMoreDescText:(NSString *)noMoreDescText;

- (void)setLoadingStyle;

- (void)setErrorStyle;

- (void)setIdleStyle;

@optional

- (void)setHiddenStyle;

@end
