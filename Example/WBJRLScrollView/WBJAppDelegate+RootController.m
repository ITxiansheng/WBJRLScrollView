//
//  WBJAppDelegate+RootController.m
//  LDWBJPullToReload
//
//  Created by ITxiansheng on 2017/1/9.
//  Copyright © 2017年 xuguoxing. All rights reserved.
//

#import "WBJAppDelegate+RootController.h"
#import "WBJRLTestRefreshVC.h"
#import "WBJRLTestLoadMoreVC.h"

#define Main_Color [UIColor colorWithRed:(3)/255.0 green:(160)/255.0 blue:(235)/255.0 alpha:1.0]

@interface WBJAppDelegate ()<UITabBarControllerDelegate>

@end

@implementation WBJAppDelegate (RootController)

- (void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)setTabbarController
{
    
    WBJRLTestRefreshVC *refreshTestVC = [[WBJRLTestRefreshVC alloc]init];
    WBJRLTestLoadMoreVC *loadMoreTestVC =[[WBJRLTestLoadMoreVC alloc]init];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[refreshTestVC,loadMoreTestVC]];
    self.viewController = tabBarController;
    tabBarController.delegate = self;
    NSArray *imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"testLoadmore.png"],[UIImage imageNamed:@"testRefresh.png"] ,nil];
    NSInteger index = 0;
    for (UITabBarItem *item in [[tabBarController tabBar] items])
    {
        [item setTitle:@[@"测试下拉刷新",@"测试上拉加载更多"][index]];
        [item setFinishedSelectedImage:imageArr[index] withFinishedUnselectedImage:imageArr[index]];
        NSDictionary *unseleAtrr = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:11],
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     };
        NSDictionary *seleAtrr = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:11],
                                   NSForegroundColorAttributeName: [UIColor redColor],
                                   };
        [item setTitleTextAttributes:unseleAtrr forState:UIControlStateNormal];
        [item setTitleTextAttributes:seleAtrr forState:UIControlStateSelected];
        index++;
    }
}

- (void)setRootViewController
{
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    navc.navigationBar.barTintColor = Main_Color;
    
    navc.navigationBar.shadowImage = [[UIImage alloc] init];
    [navc.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [navc.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navc.navigationBar.tintColor = [UIColor whiteColor];
    self.window.rootViewController = navc;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[WBJRLTestRefreshVC class]])
    {
        tabBarController.navigationItem.title = @"测试下拉刷新";
    }
    if ([viewController isKindOfClass:[WBJRLTestLoadMoreVC class]])
    {
        tabBarController.navigationItem.title = @"测试上拉加载";
    }
}

@end
