//
//  WBJRLTestScrollViewVC.m
//  LDCPPullToReload
//
//  Created by ITxiansheng on 2017/1/9.
//  Copyright © 2017年 xuguoxing. All rights reserved.
//

#import "WBJRLTestScrollViewVC.h"
#import "WBJRLTableView.h"
#import "WBJRLScrollView.h"
#import "WBJRLCollectionView.h"
#import "CustomeCollectionViewCell.h"
static NSString *categoryCellIdentifier = @"categoryCollectionViewCell";

@interface WBJRLTestScrollViewVC ()<UITableViewDataSource,UICollectionViewDataSource>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSString *scrollViewType;
@property (nonatomic,assign) WBJRLRefreshAnimationType refreshType;
@property (nonatomic,assign) WBJRLLoadMoreAnimationType loadMoreType;

@end

@implementation WBJRLTestScrollViewVC

- (instancetype)initWithScrollViewType:(NSString *)scrollViewType refreshAnimationType:(WBJRLRefreshAnimationType) refreshType loadMoreAnimationType:(WBJRLLoadMoreAnimationType) loadMoreType {

    if (self = [super init]) {
        _scrollViewType = scrollViewType;
        _refreshType = refreshType;
        _loadMoreType = loadMoreType;
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.title = self.scrollViewType;

    [WBJRLScrollViewConfig shareInstance].globalRefreshAnimationType =self.refreshType;
    [WBJRLScrollViewConfig shareInstance].globalLoadMoreAnimationType =self.loadMoreType;

    if ([self.scrollViewType isEqualToString:@"WBJRLTableView"]) {
        _scrollView = [[WBJRLTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
       ((WBJRLTableView * )self.scrollView).dataSource = self;
    }
    else if ([self.scrollViewType isEqualToString:@"WBJRLScrollView"]){
        _scrollView = [[WBJRLScrollView alloc]initWithFrame:self.view.bounds];
        
        for (int i = 0; i<2; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
            self.scrollView.backgroundColor = [UIColor greenColor];
            [self.scrollView addSubview: view];
        }
        
        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2);

        
    }else if ([self.scrollViewType isEqualToString:@"WBJRLCollectionView"]) {
        _scrollView = [[WBJRLCollectionView alloc]initWithFrame:self.view.bounds];
        [(WBJRLCollectionView *)_scrollView registerClass:[CustomeCollectionViewCell class] forCellWithReuseIdentifier:categoryCellIdentifier];

        ((WBJRLCollectionView *)self.scrollView).dataSource = self;
    }
    
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.scrollView.refreshControllView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView setLoadMoreState:WBJLoadMoreStateIdle];
    
    __weak typeof(self) weakSelf = self;
    [self.scrollView setLoadMoreBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"loadMore了");
        [strongSelf performSelector:@selector(setLoadMoreError) withObject:nil afterDelay:5];
        [strongSelf performSelector:@selector(setLoadNoMore) withObject:nil afterDelay:7];
        [strongSelf performSelector:@selector(setLoadMoreNoHiden) withObject:nil afterDelay:9];
        [strongSelf performSelector:@selector(setLoadMoreIdle) withObject:nil afterDelay:11];
        [strongSelf performSelector:@selector(setLoadMoreNone) withObject:nil afterDelay:13];
        [strongSelf performSelector:@selector(setLoadMoreIdle) withObject:nil afterDelay:15];
        
    }];
    
    [self.scrollView setRefreshBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"refresh了");
        [strongSelf performSelector:@selector(endFresh) withObject:nil afterDelay:5];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView beginRefreshAnimated:YES];
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.contentView.backgroundColor = [UIColor blueColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.scrollView beginRefreshAnimated:YES];
}


#pragma mark - UIColletionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
        return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    return CGSizeMake(40,40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (void)setLoadMoreHiden{
    self.scrollView.hideLoadMoreControllView = YES;
}
- (void)setLoadMoreNoHiden{
    self.scrollView.hideLoadMoreControllView = NO;
}
- (void)setLoadNoMore{
    [self.scrollView setLoadMoreState:WBJLoadMoreStateNoMore];
    self.scrollView.refreshAnimationType = WBJRLRefreshAnimationCat;
    
}

- (void)setLoadMoreError{
    [self.scrollView setLoadMoreState:WBJLoadMoreStateError];
}

- (void)setLoadMoreIdle{
    [self.scrollView setLoadMoreState:WBJLoadMoreStateIdle];
    self.scrollView.loadMoreHeight = 100;
    
}

- (void)setLoadMoreNone{
    [self.scrollView setLoadMoreState:WBJLoadMoreStateNone];
    
}

- (void)endFresh{
    [self.scrollView endRefreshAnimated:YES];
    self.scrollView.refreshHeight = 60;
}

@end
