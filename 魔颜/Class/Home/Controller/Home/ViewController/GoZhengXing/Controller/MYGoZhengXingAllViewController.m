//
//  MYGoZhengXingAllViewController.m
//  魔颜
//
//  Created by abc on 16/4/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYGoZhengXingAllViewController.h"
#import "MYBeautyMenuView.h"


#import "MYBeautyServiceController.h"

#import "MYIdeaViewController.h"
#import "MYHomeDoctorTableViewController.h"
#import "MYHomeHospitalTableViewController.h"

@interface MYGoZhengXingAllViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) MYBeautyMenuView *titView;
@property(strong,nonatomic) UIButton * rightBtn;

@end

@implementation MYGoZhengXingAllViewController


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
    self.title = @"去整形";
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
    NSArray *arr = @[@"整形服务",@"医院",@"医生",@"整形攻略",];
    NSArray *imageArr = @[@"meirongfuwu",@"meirongyuan",@"meironggonglue",@"meironggonglue"];
    MYBeautyMenuView *tv = [[MYBeautyMenuView alloc] initWithFrame:CGRectMake(0, 64, MYScreenW, 50) titleArr:arr imageArr:imageArr type:@"zhengxing"];
    self.titView = tv;
    tv.titleBlock = ^(NSInteger index){
        self.scrollView.contentOffset = CGPointMake(index * MYScreenW, 0);
    };
    [self.view addSubview:tv];
}
#pragma mark 添加滚动视图
-(void)setupChildVC
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH - 64 - 50)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.y = CGRectGetMaxY(self.titView.frame);
    scrollView.contentSize = CGSizeMake(MYScreenW * 4, 1);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    MYBeautyServiceController *oneVC = [[MYBeautyServiceController alloc]init];
    [self addChildViewController:oneVC];
    [scrollView addSubview:oneVC.view];
    
    
    MYHomeHospitalTableViewController *twoVC = [[MYHomeHospitalTableViewController alloc]init];
    twoVC.view.x = MYScreenW;
    [self addChildViewController:twoVC];
    [scrollView addSubview:twoVC.view];
    
    MYHomeDoctorTableViewController *threeVC = [[MYHomeDoctorTableViewController alloc]init];
    threeVC.view.x = MYScreenW * 2;
    [self addChildViewController:threeVC];
    [scrollView addSubview:threeVC.view];

    
    MYIdeaViewController *fourVC = [[MYIdeaViewController alloc]init];
    fourVC.view.x = MYScreenW * 3;
    [self addChildViewController:fourVC];
    [scrollView addSubview:fourVC.view];
    
    
    
}
#pragma mark 监听滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titView sliderMoveToOffsetX:scrollView.contentOffset.x];
}
@end
