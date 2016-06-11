//
//  PHHomeNewViewController.m
//  FitTiger
//
//  Created by 小腊 on 16/4/6.
//  Copyright © 2016年 PanghuKeji. All rights reserved.
//

#import "MYBeautyViewController.h"

#import "MYBeautyServiceController.h"
#import "MYBeautyShopController.h"
#import "MYIdeaViewController.h"

#import "MYBeautyMenuView.h"

@interface MYBeautyViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) MYBeautyMenuView *titView;
@property(strong,nonatomic) UIButton * rightBtn;

@end

@implementation MYBeautyViewController

//在页面出现的时候就将黑线隐藏起来
-(void)viewWillAppear:(BOOL)animated
{
    //设置导航栏的背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wenli"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
//在页面消失的时候就让navigationbar还原样式
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"去美容";
    //1.添加titleView
    [self setupTitleView];
    //2.添加滚动视图
    [self setupChildVC];
   
    [self addbell];
}
-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW - 40, 30, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
//小铃铛
-(void)clickBell
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark  添加titleview视图
-(void)setupTitleView  
{
    NSArray *arr = @[@"美容服务",@"美容院",@"美容攻略"];
    NSArray *imageArr = @[@"meirongfuwu",@"meirongyuan",@"meironggonglue"];
    MYBeautyMenuView *tv = [[MYBeautyMenuView alloc] initWithFrame:CGRectMake(0, 64, MYScreenW, 50) titleArr:arr imageArr:imageArr type:nil];
    self.titView = tv;
    tv.titleBlock = ^(NSInteger index){
        self.scrollView.contentOffset = CGPointMake(index * MYScreenW, 0);
    };
    [self.view addSubview:tv];
}
#pragma mark 添加滚动视图
-(void)setupChildVC
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH - 64 - self.titView.height)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.y = CGRectGetMaxY(self.titView.frame);
    scrollView.contentSize = CGSizeMake(MYScreenW * 3, 1);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    MYBeautyServiceController *oneVC = [[MYBeautyServiceController alloc]init];
    [self addChildViewController:oneVC];
    [scrollView addSubview:oneVC.view];
    
    MYBeautyShopController *twoVC = [[MYBeautyShopController alloc]init];
    twoVC.view.x = MYScreenW;
    [self addChildViewController:twoVC];
    [scrollView addSubview:twoVC.view];
    
    MYIdeaViewController *threeVC = [[MYIdeaViewController alloc]init];
    threeVC.view.x = MYScreenW * 2;
    [self addChildViewController:threeVC];
    [scrollView addSubview:threeVC.view];
    
}
#pragma mark 监听滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titView sliderMoveToOffsetX:scrollView.contentOffset.x];
}
@end
