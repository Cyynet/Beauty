//
//  MYTiyanFirstViewController.m
//  魔颜
//
//  Created by abc on 16/5/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYTiyanFirstViewController.h"
#import "AdView.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYTiYanListCell.h"
#import "MYTiYanListModle.h"
#import "MYTopBtn.h"
#import "MYPopView.h"
#import "MYTagTool.h"
#import "MYSortsModel.h"

@interface MYTiyanFirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView * tableview;
@property(strong,nonatomic) UIView * headerview;
@property(strong,nonatomic) NSMutableArray * imageArr;
@property(strong,nonatomic) NSMutableArray * urls;
@property(strong,nonatomic) NSMutableArray * titlearr;

@property(strong,nonatomic) NSMutableArray * listdata;
/** <#注释#> */
@property (strong, nonatomic) NSMutableArray *areasArr;

@property(strong,nonatomic) UIView * topMenu;
@property(strong,nonatomic) NSArray * titles;
@property(strong,nonatomic) MYTopBtn * topBtn;
@property(strong,nonatomic) MYPopView * popView;
@property (weak, nonatomic) UIView *lastView;
@property (weak, nonatomic) UIButton *lastBtn;

@property(strong,nonatomic) NSMutableArray * sorts;
@property(strong,nonatomic) NSString * currentItem;

@property(strong,nonatomic) NSString * freshBool;
@property(strong,nonatomic) FmdbTool * fmdb;
@property(assign,nonatomic) NSInteger page;

/** (1 按照发布时间排序  2按照评论数量排序  3按照点击量排序) */
@property (copy, nonatomic) NSString *pvSort;
/**分类 */
@property (copy, nonatomic) NSString *mold;
/** 地区ID */
@property (copy, nonatomic) NSString *areaId;

@end

@implementation MYTiyanFirstViewController

/** 分类 */
- (NSMutableArray *)sorts
{
    if (!_sorts) {
        
        NSArray *arr = [MYTagTool beauties];
        _sorts = [NSMutableArray arrayWithObject:@"全部"];
        
        for (MYSortsModel *model in arr) {
            
            [_sorts addObject:model.title];
        }
    }
    return _sorts;
}
/** 地区 */
- (NSMutableArray *)areasArr
{
    if (!_areasArr) {

        _areasArr = [NSMutableArray array];
    }
    return _areasArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self setupNotification];
    [self setupTopMenu];
    [self addtableview];
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    [fmdb createFMDBTable:@"tiyan"];
    
    NSDictionary *datadict = [fmdb checkoutdata:@"tiyan"];
    
    if (datadict.count) {
        
            //获取当前页输
            NSString *numstr = [fmdb chekoutcurrpagenum:@"tiyan"];
            NSInteger numpage = [numstr integerValue];
            self.page = numpage;

        
            self.listdata =(NSMutableArray *)[MYTiYanListModle objectArrayWithKeyValuesArray:datadict[@"tiyanlist"]];

            self.imageArr = [NSMutableArray array];
            self.urls = [NSMutableArray array];
            self.titlearr = [NSMutableArray array];
            
            for (NSDictionary *dict in datadict[@"banner"])
            {
                [self.imageArr addObject:[NSString stringWithFormat:@"%@%@",kOuternet1,dict[@"pic"]]];
                [self.urls addObject:dict[@"url"]];
                [self.titlearr addObject:dict[@"title"]];
                
            }
        }else
        {
            self.freshBool = @"yes";
            [self refreshList];

        }

}
-(void)refreshList
{
    
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requsetData)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![self.freshBool isEqualToString:@"yes"]) {
        
        }else{
        
            [self.tableview.header beginRefreshing];
        }

    });
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requsermoredata];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;


}

#pragma mark--添加tableview
-(void)addtableview
{
    UITableView*tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+35, MYScreenW, MYScreenH-35-64-35)];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    [self.view addSubview:tableview];
    
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 150)];
    tableview.tableHeaderView = headerview;
    self.headerview = headerview;
    
}

#pragma mark--请求列表数据
-(void)requsetData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"pvSort"] = self.pvSort;
    param[@"mold"] = self.mold;
    param[@"areaId"] = self.areaId;
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/experience/queryExperList",kOuternet] params:nil success:^(id responseObject) {
        
        if([responseObject[@"status"] isEqualToString:@"success"])
        {
            NSArray *dataarr = [[NSArray alloc]init];
            
            dataarr = [MYTiYanListModle objectArrayWithKeyValuesArray:responseObject[@"experList"]];

            self.listdata = (NSMutableArray *)dataarr;
            
            self.imageArr = [NSMutableArray array];
            self.urls = [NSMutableArray array];
            self.titlearr = [NSMutableArray array];
            
            for (NSDictionary *dict in responseObject[@"experBanner"]) {
            
                 [self.imageArr addObject:[NSString stringWithFormat:@"%@%@",kOuternet1,dict[@"pic"]]];
                
                 [self.urls addObject:dict[@"url"]];
                [self.titlearr addObject:dict[@"title"]];
                
            }
            [self.fmdb addDataInsetTable:responseObject[@"experBanner"] listArr2:responseObject[@"experList"] listArr3:nil page:self.page type:@"tiyan"];
            
            [self loadScrollView];
            [self.tableview.header endRefreshing];
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        if (error.code == -1005) {
            
            [MBProgressHUD showError:@"请求超时"];
        }
            [self.tableview.header endRefreshing];
    }];
}

- (void)setupNotification
{
    /** 通知 */
    [MYNotificationCenter addObserver:self selector:@selector(selectedItem:) name:@"MYExperienceChange" object:nil];
 
}

- (void)selectedItem:(NSNotification *)noti
{
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    self.currentItem = noti.userInfo[@"MYTopTitle"];
    [topBtn setTitle:self.currentItem forState:UIControlStateNormal];
    
    int indexPath = [noti.userInfo[@"MYTitle"] intValue];
  
    if (topBtn.tag == 0) {
        if ([self.currentItem isEqualToString:@"最新发布"]) {
            self.pvSort = @"0";
        }else if ([self.currentItem isEqualToString:@"最多评论"]){
            self.pvSort = @"1";
        }else{
            self.pvSort = @"2";
        }
        
    }else if (topBtn.tag == 1){
        self.mold = noti.userInfo[@"MYTitle"];
    }else{
        if (indexPath) {
            self.areaId = noti.userInfo[@"MYTitle"];
         }
    }
    [self.tableview.header endRefreshing];
    [self refreshList];

}

#pragma mark-- 顶部菜单按钮
- (void)setupTopMenu
{
    UIView *topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    self.topMenu = topMenu;
    topMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMenu];
    
    UIView *driverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 3 - 0.5, 0, 1, 35)];
    driverView.backgroundColor = [UIColor lightGrayColor];
    driverView.alpha = 0.4;
    [topMenu addSubview:driverView];
    
    UIView *driverView1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 3 * 2 - 0.5, 0,1, 35)];
    driverView1.backgroundColor = [UIColor lightGrayColor];
    driverView1.alpha = 0.4;
    [topMenu addSubview:driverView1];
    
    self.titles = @[@"人气最高",@"分类",@"地区"];
    for (int i = 0; i < self.titles.count; i ++) {
        
        MYTopBtn *topBtn = [[MYTopBtn alloc] init];
        if (i == 0) {
            topBtn.frame = CGRectMake(self.view.width / 3 * i -0.5, 0, self.view.width / 3, 35);
        }else{
            topBtn.frame = CGRectMake(self.view.width / 3 * i + 0.5, 0, self.view.width / 3, 35);
        }
        [topBtn setTitle:[self.titles objectAtIndex:i]];
        [topBtn addTarget:self action:@selector(clickTopBtna:)];
        topBtn.tag = i;
        self.topBtn = topBtn;
        [_topMenu addSubview:topBtn];
    }
    
}
- (void)clickTopBtna:(UIButton *)topBtn
{
        self.lastBtn.selected = NO;
        topBtn.selected = YES;
        self.lastBtn = topBtn;
        
        [self.lastView removeFromSuperview];
        
        CGFloat popHeight = 0.0;
        CGFloat popWidth = 0.0;
        CGFloat popX = 0;
        MYPopView *popView = [MYPopView popViewWithTopBtn:topBtn];
        self.popView = popView;
        
        if (topBtn.tag == 0) {
            popHeight = 3 * MYRowHeight;
            popWidth = self.view.width / 3;
            popX = 0;
        }
        
        if (topBtn.tag == 1) {
            popHeight = 6 * MYRowHeight;
            popWidth = self.view.width / 3;
            popX = MYScreenW / 3;
        }
        if (topBtn.tag == 2) {
            popHeight = 6 * MYRowHeight;
            popWidth = self.view.width / 2;
            popX = MYScreenW *2/ 3;
            
        }
        
    NSArray *leftArr = @[@"最新发布",@"最多评论",@"最高人气"];
    NSArray *Arr =  [MYTagTool areas];
    
    for (MYSortsModel *model in Arr) {
        
        [self.areasArr addObject:model.title];
    }
    
        popView.chooseArray = [NSMutableArray arrayWithArray:@[leftArr ,self.sorts,self.areasArr]];
        popView.tag = 1;
        popView.type = @"tiyan";
        [popView showInRect:CGRectMake(popX, self.topMenu.bottom , popWidth, popHeight)];
        self.lastView = popView;
    
}

//加载轮播图
- (void)loadScrollView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    AdView *view = [AdView adScrollViewWithFrame:CGRectMake(0, 0, MYScreenW, 150) imageLinkURL:self.imageArr
                             placeHoderImageName:nil
                            pageControlShowStyle:UIPageControlShowStyleCenter];
    
    //图片被点击后回调的方法
    view.callBack = ^(NSInteger index,NSString * imageURL)
    {
        MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
        vc.tag = 2;
        vc.imageName = imageURL;
        vc.url = [self.urls objectAtIndex:index];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    [self.headerview addSubview:view];
}

-(void)requsermoredata
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"pvSort"] = self.pvSort;
    param[@"mold"] = self.mold;
    param[@"areaId"] = self.areaId;
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/experience/queryExperList",kOuternet] params:param success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableview.footer endRefreshingWithNoMoreData];
            
        }else{
            NSArray *dataarr = [[NSArray alloc]init];
            
            dataarr = [MYTiYanListModle objectArrayWithKeyValuesArray:responseObject[@"experList"]];
            
            [self.listdata addObjectsFromArray:dataarr];
      
            [self.fmdb addDataInsetTable:nil listArr2:responseObject[@"experList"] listArr3:nil page:self.page type:@"tiyan"];
            
            [self.tableview reloadData];
            [self.tableview.footer endRefreshing];
        }

    } failure:^(NSError *error) {
            [self.tableview.footer endRefreshing];
        
    }];
    
    
    
}

#pragma mark --代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listdata.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYTiYanListCell *cell = [MYTiYanListCell cellWithTableView:tableView indexPath:indexPath];
    MYTiYanListModle *modle = self.listdata[indexPath.row];
    cell.tiyanmodle = modle;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 225+117;
}
@end
