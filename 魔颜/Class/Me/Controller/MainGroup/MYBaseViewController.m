//
//  WQTabBarController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYBaseViewController.h"
#import "MYLoginViewController.h"

#import "MYBaseGroup.h"
#import "MYBaseItem.h"
#import "MYBaseCell.h"
#import "MYArrowItem.h"

@interface MYBaseViewController ()<RCIMUserInfoDataSource>

@property (strong, nonatomic) NSMutableArray *groups;

@property(strong, nonatomic)NSString *kefuid;
@end

@implementation MYBaseViewController

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        
        _groups = [NSMutableArray array];
    }
    return _groups;
    
}

-(instancetype)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置tableView属性

    self.tableView.rowHeight = MYRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [MYNotificationCenter addObserver:self selector:@selector(login) name:@"LoginSuccess" object:nil];
    [self loadKeFuId];
}

- (void)login
{
    self.isLogin = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    MYBaseGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYBaseCell *cell = [MYBaseCell cellWithTableView:tableView];

    MYBaseGroup *group = self.groups[indexPath.section];
    
    cell.item = group.items[indexPath.row];
    
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中哪一行
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!deleate.isLogin) {
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
            [MBProgressHUD showError:@"您还未登录，请先登录"];
            
        } completion:^(BOOL finished) {
            [MBProgressHUD hideHUD];
        }];
        
        [MBProgressHUD showError:@"您还未登录，请您先登录"];
        
        
    }else{
    
        // 1.取出这行对应的item模型
        MYBaseGroup *group = self.groups[indexPath.section];
        MYBaseItem *item = group.items[indexPath.row];
        
        // 2.判断有无需要跳转的控制器
        if (item.optional) {
            
            if (item.isLogin) {
                
            }
            item.optional();
        }else if (indexPath.section == 0 && indexPath.row == 1)
        {
            //    和容云断开链接 以便再次连接
            [[RCIMClient sharedRCIMClient] disconnect:YES];
            
            if (MYAppDelegate.isLogin) {
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
                         conversationVC.navigationController.navigationBar.hidden = NO;
                      
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
            }else
            {
                MYLoginViewController *loginVC = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES
                 ];
            }
        
            
        }
        else if([item isKindOfClass:[MYArrowItem class]]) {
            
            MYArrowItem *arrowItem = (MYArrowItem *)item;
            
            UIViewController *destVC = [[arrowItem.destVC alloc]init];
            destVC.title = item.title;
            
            [self.navigationController pushViewController:destVC animated:YES];
            self.navigationController.navigationBarHidden = NO;
        }
        
        
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
