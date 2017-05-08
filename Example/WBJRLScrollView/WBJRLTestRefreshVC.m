//
//  WBJRLTestRefreshVC.m
//  LDWBJPullToReload
//
//  Created by ITxiansheng on 2017/1/9.
//  Copyright © 2017年 xuguoxing. All rights reserved.
//

#import "WBJRLTestRefreshVC.h"
#import "WBJConfig.h"
#import "WBJRLTestScrollViewVC.h"
@interface WBJRLTestRefreshVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableview;

@end
@implementation WBJRLTestRefreshVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试下拉刷新";
    [self.view addSubview:self.tableview];
}


#pragma mark - UITableViewDataSource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[WBJConfig shareInstance].scrollTypes count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[WBJConfig shareInstance].refreshTestTypes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [WBJConfig shareInstance].refreshTestTypes[indexPath.row];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backgrounView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableview.bounds), 20)];
    backgrounView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableview.bounds),20)];
    titleLabel.font =[UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = [WBJConfig shareInstance].scrollTypes[section];
    [backgrounView addSubview:titleLabel];
    return backgrounView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //通过indexPath.row+1 决定 下拉刷新类型，上拉类型为 1；
    WBJRLTestScrollViewVC * scrollViewVC = [[WBJRLTestScrollViewVC alloc]initWithScrollViewType:[WBJConfig shareInstance].scrollTypes[indexPath.section] refreshAnimationType:indexPath.row+1 loadMoreAnimationType:1] ;
    
    [self.navigationController pushViewController:scrollViewVC animated:YES];
}

#pragma getter

-(UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}

@end
