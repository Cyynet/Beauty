//
//  MYHomeDiscountListTableViewController.m
//  魔颜
//
//  Created by abc on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeDiscountListTableViewController.h"
#import "MYTopBtn.h"
#import "MYPopView.h"

#import "MYDiscountListModel.h"
#import "MYHomeDiscountListTableViewCell.h"

#import "MYProgectCell.h"
#import "MYDiscount.h"

#import "MYLoginViewController.h"
#import "MYHomeHospitalDeatilViewController.h"

#define MYTopMenuW MYScreenW * 0.33
#define MYTopMenuH MYScreenH * 0.066
@interface MYHomeDiscountListTableViewController ()<UITableViewDelegate,UITableViewDataSource,RCIMUserInfoDataSource>

@property(strong,nonatomic) NSMutableArray * discountListData;

@property(weak, nonatomic) UIView *topMenu;
@property(weak, nonatomic) UIButton *topBtn;
@property(strong,nonatomic) UIView * popView;


@property(copy, nonatomic) NSString *currentTopName;

@property (copy, nonatomic) NSString *selectedStyle;
@property (copy, nonatomic) NSString *selectedType;


@property(strong, nonatomic) NSArray *titles;
@property (weak, nonatomic) UIView *lastView;

@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property(strong,nonatomic) UIButton * rightbtn;
@property(strong, nonatomic) NSString *kefuid;

@end

@implementation MYHomeDiscountListTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self addbell];
    [MobClick beginLogPageView:@"商城二级列表"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.popView removeFromSuperview];
    self.rightbtn.hidden = YES;
    [MobClick endLogPageView:@"商城二级列表"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTopMenu];
    

    [self setupTableView];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self setupNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.tag;
    
    //下拉刷新-----------------------------------
    [self refreshDiscountListData];
    
    //上拉刷新------------------------------------
    [self reloadMore];
    self.page = 1;//-------------------------------
    
    [self loadKeFuId];
}

//刷新-------------------------------
-(void)refreshDiscountListData
{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDiscountLista)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.header beginRefreshing];
    });
    
}

/*
 @brief 加载更多数据--------------------------
 */
- (void)reloadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableView.footer.automaticallyChangeAlpha = YES;
    
}

//上拉加载更多--------------------------------------
- (void)setupMoreData
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"type"] = self.navTitle;
    param[@"order_by"] =  self.selectedStyle;
    param[@"order_by_type"] =  self.selectedType;
    param[@"hospitalId"] = self.hospitalId;
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/specialdeals/querySpecialdealsInfoList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            
            NSArray *newdeatildata = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"querySpecialdealsInfoList"]];
            
            [self.discountListData  addObjectsFromArray:newdeatildata];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.tableView.footer endRefreshing];
                [self.tableView.footer resetNoMoreData];
            });
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.footer endRefreshing];
        [self.tableView.footer resetNoMoreData];
    }];
    
}

//  请求数据
-(void)requestDiscountLista
{
    
    [self.discountListData removeAllObjects];
    
    AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"type"] =  self.navTitle;
    param[@"hospitalId"] = self.hospitalId;
    param[@"order_by"] =  self.selectedStyle;
    param[@"order_by_type"] =  self.selectedType;
    
    [marager POST:[NSString stringWithFormat:@"%@specialdeals/querySpecialdealsInfoList",kOuternet1] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *newdiscountListData = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"querySpecialdealsInfoList"]];
        
        self.discountListData = (NSMutableArray *)newdiscountListData;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer resetNoMoreData];
        
        self.page = 1;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.tableView.header endRefreshing];
    }];
}

//顶部菜单按钮
- (void)setupTopMenu
{
    UIView *topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, MYTopMenuH)];
    self.topMenu = topMenu;
    [self.view addSubview:topMenu];
    
    UIView *driverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 0.5, 0, 1, 35)];
    driverView.backgroundColor = [UIColor lightGrayColor];
    driverView.alpha = 0.4;
    [topMenu addSubview:driverView];
    
    UIView *driverView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5 , self.view.width, 0.5)];
    driverView1.backgroundColor = [UIColor lightGrayColor];
    driverView1.alpha = 0.4;
    [topMenu addSubview:driverView1];
    
    
    self.titles = @[@"价格",@"时间"];
    for (int i = 0; i < self.titles.count; i ++) {
        
        MYTopBtn *topBtn = [[MYTopBtn alloc] init];
        if (i == 0) {
            topBtn.frame = CGRectMake(self.view.width / 2 * i -0.5, 0, self.view.width / 2, 35);
        }else{
            topBtn.frame = CGRectMake(self.view.width / 2 * i + 0.5, 0, self.view.width / 2, 35);
        }
        [topBtn setTitle:[self.titles objectAtIndex:i]];
        [topBtn addTarget:self action:@selector(clickTopBtn:)];
        topBtn.tag = i;
        self.topBtn = topBtn;
        [_topMenu addSubview:topBtn];
    }
    
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, CGRectGetMaxY(self.topMenu.frame), self.view.width, self.view.height - self.topMenu.height - 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
}

- (void)setupNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleChanged:) name:@"MYHospitalTitleChange" object:nil];
}

//筛选
- (void)titleChanged:(NSNotification *)noti
{
    self.currentTopName = noti.userInfo[@"MYTopTitle"];
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    if (topBtn.tag == 0) {
        
        self.selectedStyle = @"DISCOUNT_PRICE";
        if ([self.currentTopName isEqualToString:@"高-低"]) {
            self.selectedType = @"desc";
            [topBtn setTitle:[NSString stringWithFormat:@"价格:%@",self.currentTopName] forState:UIControlStateNormal];
        }
        else if ([self.currentTopName isEqualToString:@"低-高"]){
            self.selectedType = @"asc";
            [topBtn setTitle:[NSString stringWithFormat:@"价格:%@",self.currentTopName] forState:UIControlStateNormal];
        }else{
            self.selectedType = nil;
            [topBtn setTitle:@"价格" forState:UIControlStateNormal];
        }
    }
    else {
        
        self.selectedStyle = @"TIME";
        if ([self.currentTopName isEqualToString:@"最新发布"])
        {
            self.selectedType = @"desc";
            [topBtn setTitle:[NSString stringWithFormat:@"时间:%@",self.currentTopName] forState:UIControlStateNormal];
        }
        else if ([self.currentTopName isEqualToString:@"最早发布"]){
            
            self.selectedType = @"asc";
            [topBtn setTitle:[NSString stringWithFormat:@"时间:%@",self.currentTopName] forState:UIControlStateNormal];
        }
        else{
            self.selectedType = nil;
            [topBtn setTitle:@"时间" forState:UIControlStateNormal];
        }
    }
    [self refreshDiscountListData];
}

- (void)clickTopBtn:(UIButton *)topBtn
{
    [self.lastView removeFromSuperview];
    
    CGFloat popX = 0;
    CGFloat popHeight = 0;
    if (topBtn.tag == 0) {
        popHeight = 3 * MYRowHeight;
    }else {
        popHeight = 3 * MYRowHeight;
        popX = MYScreenW / 2;
     }
    
    MYPopView *popView = [MYPopView popViewWithTopBtn:topBtn];
    self.popView = popView;
    popView.chooseArray = [NSMutableArray arrayWithArray:@[
         @[@"不限",@"高-低",@"低-高"],
    @[@"不限",@"最新发布",@"最早发布"],
      ]];
    [popView showInRect:CGRectMake(popX, -7, self.view.width / 2, popHeight)];
    self.lastView = popView;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.discountListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYProgectCell *cell = [MYProgectCell progectCell];
    
    if (self.discountListData.count == 0) {
        return cell;
    }else{
        cell.progect = self.discountListData[indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYHomeHospitalDeatilViewController  *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
    [self.navigationController pushViewController:deatilevc animated:YES];
    MYDiscount *discountListmodel = self.discountListData[indexPath.row];
    deatilevc.titleName = discountListmodel.title;
    deatilevc.imageName = discountListmodel.smallPic;
    deatilevc.character = discountListmodel.hospitalName;
    deatilevc.id = discountListmodel.id;
    deatilevc.tag = 1;

    
}

-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightbtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW -66, 15, 50, 50);
    [rightBtn setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:rightBtn];
    
}
//小铃铛
-(void)clickBell
{
    //和容云断开链接 以便再次连接
    [[RCIMClient sharedRCIMClient] disconnect:YES];
    
    AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (deleate.isLogin) {
        NSString *token =   [MYUserDefaults objectForKey:@"token"];
        //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                //   跳转客服
                RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
                [conversationVC.view removeFromSuperview];
                conversationVC.conversationType = ConversationType_APPSERVICE;
                conversationVC.targetId =  self.kefuid;
                conversationVC.userName = @"张哲";
                conversationVC.title = @"客服";
                [self.navigationController pushViewController:conversationVC animated:YES];
                
            });
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
            NSMutableDictionary *parma = [NSMutableDictionary dictionary];
            
            parma[@"id"] = [MYUserDefaults objectForKey:@"id"];
            
            [marager GET:[NSString stringWithFormat:@"%@user/reGetToken",kOuternet1] parameters:parma success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSString *ToKen = responseObject[@"token"];
                [MYUserDefaults setObject:ToKen forKey:@"token"];
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            
        }];
    }else{
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
//获取客服ID
-(void)loadKeFuId
{
    AFHTTPRequestOperationManager *KeFuIdmager = [[ AFHTTPRequestOperationManager alloc]init];
    
    [KeFuIdmager GET:[NSString stringWithFormat:@"%@/kefu/serverId",kOuternet1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            self.kefuid = responseObject[@"kefu_id"];
            //            [MYUserDefaults setObject:self.kefuid forKey:@"kefu_id"];
            //            [MYUserDefaults synchronize];
        }else{
            [MBProgressHUD showError:@"请稍后联系"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

@end
