//
//  WQTranformationTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//
#import "MYTranformationTableViewController.h"

#import "MYDetailViewController.h"

#import "MYTrasformNoticeView.h"
#import "MYLoginViewController.h"

#import "MYTranformationHeaderview.h"

#import "MYHomeTableViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeDoctorDeatilTableViewController.h"

#import "MYTieziModel.h"
#import "MYTieziMyCell.h"
#import "TextFlowView.h"
// 颜色
#define MYColorRGB [UIColor colorWithRed:127/255.0 green:81/255.0 blue:98/255.0 alpha:1.0]
@interface MYTranformationTableViewController ()<UIScrollViewDelegate,quzhoudelegate,lianxingdelegate,yanmeidelegate,bibudelegate,kouchundelegate,xiongdelegate,shentishuxingdelegate,RCIMUserInfoDataSource,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UIView *headerview;

@property(strong,nonatomic) MYTranformationHeaderview *headerbtn;


@property(strong,nonatomic) UIView *meumview;
@property(strong,nonatomic) UIButton * cricleconver;
@property (weak, nonatomic) UIButton *allBtn;
@property (weak, nonatomic) UIButton *goodBtn;
@property (weak, nonatomic) UIButton *earalyBtn;
@property (weak, nonatomic) UIButton *lastBtn;

@property(strong,nonatomic) NSMutableArray * modelsArr;

@property(strong,nonatomic) UIView *vMarqueeContainer;

@property (copy, nonatomic) NSString *isEssence;
@property (copy, nonatomic) NSString *isNew;
@property (nonatomic, assign) NSInteger page;

@property(strong,nonatomic) NSString * tag;

@property(strong,nonatomic) NSString * noticeContent;//通知内容

@property(strong, nonatomic)NSString *kefuid;

@property(strong,nonatomic) UITableView * tableview;
@property(strong,nonatomic) UIButton * topview;


@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * freshBool;
@property(strong,nonatomic) NSString * str;
@end

@implementation MYTranformationTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = NO;
    [MobClick beginLogPageView:@"魔镜列表"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"魔镜列表"];
}

- (NSMutableArray *)modelsArr
{
    if (!_modelsArr) {
        _modelsArr = [NSMutableArray array];
    }
    return  _modelsArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.page = 1;//----------
    
       [self setupFMDB];
    
    [self addtableview];
    
    [self addbellBtn];
    
    
    [self addheaderview];
    //下拉刷新-----------------------------------
    [self refreshHospitalData];
    //上拉刷新------------------------------------
    [self reloadMore];
   
    [self loadKeFuId];
    
    [self addGotoTopview];
}
-(void)setupFMDB
{
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    
    
    NSString *str  =  [_fmdb createFMDBTable:@"tranform"];
    self.str = str;
    NSString *numstr = [fmdb chekoutcurrpagenum:@"tranform"];
    
    NSArray *dataarr =  [fmdb outdata:@"tranform"];
    if (dataarr.count) {
        
        //获取当前页输
        NSInteger numpage = [numstr integerValue];
        self.page = numpage;
        
        NSArray *newdotordata = [MYTieziModel  objectArrayWithKeyValuesArray:dataarr];
        
        self.modelsArr = (NSMutableArray *)newdotordata;
        
    }else{
        
        //下拉刷新-----------------------------------
        [ self refreshHospitalData];
        self.freshBool =  @"yes";
    }
    
}
//置顶控件
-(void)addGotoTopview
{
    UIButton *topview = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW-60, MYScreenH-120, 50, 50)];
    [self.view addSubview:topview];
    self.topview = topview;
    [topview setImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
    [topview addTarget:self action:@selector(clickTopbtn) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)clickTopbtn
{
    //    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableview setContentOffset:CGPointMake(0, -63) animated:YES];
    
}
-(void)addbellBtn
{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBell) image:@"bell" highImage:@"bell"];
    
//    
//    
//    UIButton *bellBtn = [[UIButton alloc]init];
//    bellBtn.frame = CGRectMake(MYScreenW - 80, 100, 50, 50);
//    [bellBtn setImage:[UIImage imageWithName:@"bell"] forState:UIControlStateNormal];
//    [bellBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rigthItem  = [[UIBarButtonItem alloc]initWithCustomView:bellBtn];
//    self.navigationItem.rightBarButtonItem = rigthItem;
//    bellBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 10, 0, 0);
    
}

-(void)addtableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    
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


//小铃铛
-(void)clickBell
{
    //    和容云断开链接 以便再次连接
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
                conversationVC.targetId = self.kefuid;
                conversationVC.userName = @"张哲";
                conversationVC.title = @"客服";
                [self.navigationController pushViewController:conversationVC animated:YES];
                
            });
        } error:^(RCConnectErrorCode status) {
            
            NSLog(@"-------tuobian-%ld-",(long)status);
            
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


//刷新-------------------------------
- (void)refreshHospitalData
{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setuprequestData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
            [self.tableview.header beginRefreshing];
        }
    });
}

//添加帖子种类
-(void)addthreeBtn
{
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.frame = CGRectMake(-1, CGRectGetMaxY(self.headerbtn.frame) + 5, MYScreenW /3+1, 30 - 1);
    [btn1 setTitle:@"全部帖子" forState:UIControlStateNormal];
    [btn1 setTitleColor:titlecolor forState:UIControlStateNormal];
    btn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [btn1 addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleColor:MYColorRGB forState:UIControlStateSelected];
    self.allBtn = btn1;
    btn1.tag = 0;
    self.allBtn.selected = YES;
    btn1.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    [self.headerview addSubview:btn1];
    
    
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.frame = CGRectMake(MYScreenW/3, btn1.y, MYScreenW /3, 30 - 1);
    [btn2 setTitle:@"最新发布" forState:UIControlStateNormal];
    [btn2 setTitleColor:titlecolor forState:UIControlStateNormal];
    btn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [btn2 setTitleColor:MYColorRGB forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
    self.goodBtn = btn2;
    btn2.tag = 2;
    btn2.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    [self.headerview addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc]init];
    btn3.frame = CGRectMake(MYScreenW/3*2, btn1.y, MYScreenW /3+1, 30 - 1);
    [btn3 setTitle:@"精华帖" forState:UIControlStateNormal];
    [btn3 setTitleColor:titlecolor forState:UIControlStateNormal];
    btn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [btn3 setTitleColor:MYColorRGB forState:UIControlStateSelected];
    [btn3 addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
    btn3.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    self.earalyBtn = btn3;
    btn3.tag = 1;
    [self.headerview addSubview:btn3];
    
    
    //分割线
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor grayColor];
    view1.frame = CGRectMake(MYScreenW / 3-1, 0, 1, 30);
    view1.alpha = 0.4;
    [btn1 addSubview:view1];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor grayColor];
    view2.frame = CGRectMake(MYScreenW / 3-1, 0, 1, 30);
    view2.alpha = 0.4;
    [btn2 addSubview:view2];
    
    UIView *view3 = [[UIView alloc]init];
    [self.headerview addSubview:view3];
    view3.frame = CGRectMake(0, CGRectGetMaxY(self.headerbtn.frame) + 4, MYScreenW, 0.5);
    view3.backgroundColor = [UIColor lightGrayColor];
    view3.alpha = 0.5;
    
    UIView *view4 = [[UIView alloc]init];
    [self.headerview addSubview:view4];
    view4.frame = CGRectMake(0, CGRectGetMaxY(self.allBtn.frame)+1, MYScreenW, 0.6);
    view4.backgroundColor = [UIColor lightGrayColor];
    view4.alpha = 0.5;
    
    
}

/*
 @brief 点击 全部、精华帖、最新贴
 */
-(void)clickbtn:(UIButton *)btn
{
    self.allBtn.selected = NO;
    
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    
    if (btn.tag == 1) {
        
        self.isEssence = @"1";
        self.isNew = nil;
        
    }else if (btn.tag == 2){
        
        self.isNew = @"desc";
        self.isEssence = nil;
        
    }else{
        
        self.isNew = nil;
        self.isEssence = nil;
    }
    [self setuprequestData];
    
}

//请求数据
-(void)setuprequestData
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [UIColor clearColor];
    hud.alpha = 0.8;
    hud.activityIndicatorColor = UIColorFromRGB(0xbcaa7c);
    
    
    [self.modelsArr removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //    param[@"type"] = @"0";
    param[@"order"] = self.isNew;
    param[@"isEssence"] = self.isEssence;
    param[@"secProCode"] = self.tag;
    param[@"ver"] = MYVersion;
    
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryDiaryList",kOuternet1] params:param success:^(id responseObject) {
        
        if (param[@"order"] ==nil & param[@"isEssence"]==nil&param[@"secProCode"]==nil) {
            
            [self.fmdb deleteData:@"tranform"];
        }
        
        
        [hud hide:YES];
        
        NSArray *modelArr = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
        
        if(modelArr.count==0)
        {
            return ;
            
        }else{
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, modelArr.count)];
            
            [self.modelsArr insertObjects:modelArr atIndexes:indexSet];
        }
        
        if ([_str isEqualToString:@"yes"]) {
            if (param[@"order"] ==nil & param[@"isEssence"]==nil&param[@"secProCode"]==nil) {
                
                [_fmdb addDataInsetTable:responseObject[@"diaryLists"] page:1 datacount:nil type:@"tranform"];
            }
            
        }else
        {
            return;
        }

        
        [self.tableview reloadData];
        [self.tableview.header endRefreshing];
        [self.tableview.footer resetNoMoreData];
        
        self.tag =nil;
        //        self.isEssence =nil;
        //        self.isNew =nil;
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [self.tableview.header endRefreshing];
        
    }];
}

-(void)addheaderview
{
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 150)];
    self.tableview.tableHeaderView = headerview;
    self.headerview = headerview;
    headerview.backgroundColor = [UIColor whiteColor];
    
    
    UIScrollView *headerscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW , 80)];
    
    if (MYScreenW >= 414)
    {
        headerscrollview.contentSize = CGSizeMake( MYScreenW * 2 *9/10 -170 , 0);
    }
    else if (MYScreenW >= 375)
    {
        headerscrollview.contentSize = CGSizeMake( MYScreenW * 2 *9/10-170  , 0);
        
    }
    else{
        headerscrollview.contentSize = CGSizeMake( MYScreenW *2* 9/8-170   , 0);
    }
    
    headerscrollview.delegate = self;
    headerscrollview.bounces = NO;
    headerscrollview.showsHorizontalScrollIndicator = NO;
    [headerview addSubview:headerscrollview];
    
    //添加9个btn
    MYTranformationHeaderview *headerbtn = [[MYTranformationHeaderview alloc]initWithFrame:CGRectMake(0, 0, MYScreenW *2, 80)];
    
    headerbtn.quzhouq= self;
    headerbtn.lianxing = self;
    headerbtn.yanmie = self;
    headerbtn.bibu = self;
    headerbtn.kouchun = self;
    headerbtn.xiong = self;
    headerbtn.shentishuxing = self;
    
    self.headerbtn = headerbtn;
    [headerscrollview addSubview:headerbtn];
    
    //    3个帖子分类
    [self addthreeBtn];
    
    //    通知
    [self addnotiview];
    
}

//通知
-(void)addnotiview
{
    UILabel *notilable = [[UILabel alloc]init];
    [self.headerview addSubview:notilable];
    notilable.backgroundColor = subTitleColor;
    notilable.textColor = [UIColor whiteColor];
    notilable.text = @"温馨提示";
    notilable.textAlignment = NSTextAlignmentLeft;
    notilable.font = MYFont(11);
    notilable.frame = CGRectMake(8, CGRectGetMaxY(self.allBtn.frame) + 8, 45, 18);

    
    AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
    
    [marager GET:[NSString stringWithFormat:@"%@/notice/queryNotice",kOuternet1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString * noticeContent = responseObject[@"noticeContent"];
        
        TextFlowView *paoMaView = [[TextFlowView alloc] initWithFrame:CGRectMake(55, CGRectGetMaxY(self.allBtn.frame)+2, self.view.width, 30) Text:[NSString stringWithFormat:@"  %@     %@ ",noticeContent,noticeContent]];
        
        [self.headerview addSubview:paoMaView];
        //        UIView *lineView = [[UIView alloc]init];
        //        lineView.backgroundColor = [UIColor grayColor];
        //        lineView.frame = CGRectMake(0, paoMaView.y + 30, self.view.width, 1);
        //        lineView.alpha = 0.3;
        //        [self.view addSubview:lineView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYTieziMyCell *cell = [MYTieziMyCell cellWithTableView:tableView indexPath:indexPath];
    if (self.modelsArr.count == 0) {
        return cell;
    }else{
        MYTieziModel  *model = self.modelsArr[indexPath.row];
        cell.tieziModel = model;
        cell.releatedView.myBlock = ^(NSInteger type,NSString *id,NSString *name,NSString *imageURL){
            
            if (type) {
                MYHomeHospitalDeatilViewController  *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
                [self.navigationController pushViewController:deatilevc animated:YES];
                
                deatilevc.titleName = name;
                deatilevc.imageName = imageURL;
                //                deatilevc.character = discountListmodel.hospitalName;
                deatilevc.id = id;
                deatilevc.tag = 1;
                
            }else{
                
                MYHomeDoctorDeatilTableViewController *DoctorDeatilVC = [[MYHomeDoctorDeatilTableViewController alloc]init];
                [self.navigationController pushViewController:DoctorDeatilVC animated:YES];
                DoctorDeatilVC.id = id;
                
            }
            
        };
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
    
    return cell.height;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYTieziModel  *model = self.modelsArr[indexPath.row];
    MYDetailViewController *circleDeatilVC = [[MYDetailViewController alloc]init];
    circleDeatilVC.id = model.id;
    [self.navigationController pushViewController:circleDeatilVC animated:YES];
    
}

/*
 @brief 加载更多数据--------------------------
 */
- (void)reloadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;
    
}

//上拉加载更多--------------------------------------
- (void)setupMoreData
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"order"] = self.isNew;
    param[@"isEssence"] = self.isEssence;
    param[@"secProCode"] = self.tag;
    param[@"ver"] = MYVersion;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryDiaryList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableview.footer endRefreshingWithNoMoreData];
            self.page = 1;
        }else{
            
            NSArray *newdeatildata = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            
            [self.modelsArr  addObjectsFromArray:newdeatildata];
            [self.tableview reloadData];
            
            if ([_str isEqualToString:@"yes"]) {
                
                if (param[@"order"] ==nil & param[@"isEssence"]==nil&param[@"secProCode"]==nil){
               
                    [_fmdb addDataInsetTable:responseObject[@"diaryLists"] page:self.page datacount:nil type:@"tranform"];
                }
                
            }else
            {
                return;
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.tableview.footer endRefreshing];
            });
        }
        
    } failure:^(NSError *error) {
        
        [self.tableview.footer endRefreshing];
    }];
}

//顶部的代理
-(void)quzhou
{
    NSString *tag1 = [NSString stringWithFormat:@"%d",13];
    
    self.tag = tag1;
    
    self.isEssence = nil;
    self.isNew = nil;
    [self setuprequestData];
}

-(void)lianxing
{
    NSString *tag3 = [NSString stringWithFormat:@"%d",7];
    
    self.tag = tag3;
    self.isEssence = nil;
    self.isNew = nil;
    [self setuprequestData];
    
}
-(void)yanmei
{
    NSString *tag4 = [NSString stringWithFormat:@"%d",3];
    
    self.tag = tag4;
    self.isEssence = nil;
    self.isNew = nil;
    [self setuprequestData];
    
}
-(void)bibu
{
    NSString *tag5 = [NSString stringWithFormat:@"%d",5];
    
    self.tag = tag5;
    self.isEssence = nil;
    self.isNew = nil;
    [self setuprequestData];
    
}
-(void)kouchun
{
    NSString *tag6 = [NSString stringWithFormat:@"%d",6];
    
    self.tag = tag6;
    self.isEssence = nil;
    self.isNew = nil;
    [self setuprequestData];
    
}
-(void)xiong
{
    NSString *tag7 = [NSString stringWithFormat:@"%d",18];
    
    self.tag = tag7;
    self.isEssence = nil;
    self.isNew = nil;
    [self setuprequestData];
    
}
-(void)shentishuxing
{
    NSString *tag8 = [NSString stringWithFormat:@"%d",19];
    
    self.tag = tag8;
    self.isEssence = nil;
    self.isNew = nil;
    [self setuprequestData];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= 1600)
    {
        self.topview.hidden = YES;
        
    }else{
        self.topview.hidden = NO;
    }
}

@end
