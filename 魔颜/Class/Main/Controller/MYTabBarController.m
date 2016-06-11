//
//  WQTabBarController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYTabBarController.h"
#import "MYHomeViewController.h"
#import "MYMeTableViewController.h"
#import "MYTranformationTableViewController.h"
#import "MYNavigateViewController.h"


//#import "MYDiscountStoreViewController.h"
#import "MYTiyanFirstViewController.h"

// iOS7
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

@interface MYTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYHomeViewController *home = [[MYHomeViewController alloc]init];
    [self addChildVC:home title:@"首页" imageName:@"tabbar_icon_home_Normal" selIamgeName:@"tabbar_icon_home_Highlight"];
    
    MYTranformationTableViewController *traformation = [[MYTranformationTableViewController alloc]init];
    [self addChildVC:traformation title:@"魔镜" imageName:@"tabbar_icon_mojing_Normal" selIamgeName:@"tabbar_icon_mojing_Highlight"];
    
    MYTiyanFirstViewController *discount = [[MYTiyanFirstViewController alloc]init];
//    discount.scrollPoint = MYScreenW;
    [self addChildVC:discount title:@"体验" imageName:@"tabbar_icon_Sale_Normal" selIamgeName:@"tabbar_icon_Sale_Highlight"];
    
    MYMeTableViewController *profile = [[MYMeTableViewController alloc]init];
    [self addChildVC:profile title:@"我的" imageName:@"tabbar_icon_me_Normal" selIamgeName:@"tabbar_icon_me_Highlight"];
    
    self.tabBar.tintColor=[UIColor grayColor];
    
}
-(void)addChildVC:(UIViewController *)VC title:(NSString *)title imageName:(NSString *)imageName selIamgeName:(NSString *)selImageName
{
//    VC.view.backgroundColor = [UIColor whiteColor];
    VC.title = title;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MYRedColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    // ios7之后系统会自动渲染图片，对tabBarItem的selected图片进行处理
    UIImage *selImage = [UIImage imageNamed:selImageName];
    
    // 不让系统处理图片变蓝
    
    if (iOS7) {
        
        selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    [VC.tabBarItem setImage:[UIImage imageWithName:imageName]];
    [VC.tabBarItem setSelectedImage:selImage];
    
    MYNavigateViewController *nav = [[MYNavigateViewController alloc]initWithRootViewController:VC];
    
    // 添加到tabBarController
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex) {
        
        if (tabIndex == 0 || tabIndex ==  3) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            MYAppDelegate.isDefault = YES;
        }else{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            
        }
    }
}
@end
