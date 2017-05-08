//
//  WBJWBJRLCollectionView.m
//  Pods
//
//  Created by ITxiansheng on 16/7/1.
//
//

#import "WBJRLCollectionView.h"

@implementation WBJRLCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout   {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        self.alwaysBounceVertical = YES;
        WBJRLRefreshControllView * refreshControllView = [[WBJRLRefreshControllView alloc] initWithFrame:frame];
        self.refreshControllView = refreshControllView ;
        WBJRLLoadMoreControlView *loadMoreControllView = [[WBJRLLoadMoreControlView alloc] init];
        self.loadMoreControllView =loadMoreControllView;
        self.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf4/255.0 alpha:1.0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return [self initWithFrame:frame collectionViewLayout:layout];
}


@end
