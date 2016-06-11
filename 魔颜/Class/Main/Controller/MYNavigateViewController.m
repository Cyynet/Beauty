//
//  WQNavigateViewController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYNavigateViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "LOLScanViewController.h"
@interface MYNavigateViewController ()

@end

@implementation MYNavigateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    // 清空弹出手势的代理，就可以恢复弹出手势
//    self.interactivePopGestureRecognizer.delegate = nil;
//    // 获取系统自带滑动手势的target对象  // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    id target = self.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = (id)self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//}
//// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
//// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }  return YES;

//    // 获取系统自带滑动手势的target对象  // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    id target = self.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = (id)self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//}
//// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
//// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }  return YES;

}

+ (void)initialize
{
    [self setupNavigationBar];
    [self setupBarBtnItem];
    
}

+(void)setupNavigationBar
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:UIColorFromRGB(0xeaeaea)];
    navBar.translucent = YES;
    
    
    // title
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSForegroundColorAttributeName] = titlecolor;
    attrDict[NSFontAttributeName] = MYSFont(15);
    [navBar setTitleTextAttributes:attrDict];
    
}

+(void)setupBarBtnItem
{
    UIBarButtonItem *barBtnItem = [UIBarButtonItem appearance];
    // nor
    NSMutableDictionary *norAttrDict = [NSMutableDictionary dictionary];
    norAttrDict[NSForegroundColorAttributeName] = titlecolor;
    norAttrDict[NSFontAttributeName] = MYSFont(15);
    [barBtnItem setTitleTextAttributes:norAttrDict forState:UIControlStateNormal];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        // 默认每个push进来的控制器左右都有返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back-1" highImage:@"back-1"];
        viewController.hidesBottomBarWhenPushed = YES;
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

@end
