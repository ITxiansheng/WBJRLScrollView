//
//  UIImage+LDCPPullToReloadBundle.m
//  Pods
//
//  Created by asshole on 16/12/13.
//
//

#import "UIImage+WBJPullToReloadBundle.h"
#import "WBJRLCollectionView.h"
@implementation UIImage (WBJPullToReloadBundle)

+ (nullable UIImage *)pullToReload_imageNamed:(NSString *)name
{
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        static NSBundle *bundle;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bundle = [NSBundle bundleForClass:[WBJRLCollectionView class]];
        });
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageNamed:name];
    }
}

@end
