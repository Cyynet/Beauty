//
//  MYHomeHospitalDeatilViewController.m
//  魔颜
//
//  Created by abc on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeDoctorTableViewController.h"
#import "MYHomeDiscountListTableViewController.h"

#import "MYHomeDoctorDeatilTableViewController.h"
#import "MYDiscountDinggouViewController.h"
#import "LOLShareBtn.h"
#import "LOLShareView.h"
#import "WXApi.h"
#import "MYSalonModel.h"
#import "MYLoginViewController.h"

#import "MYHomeDesignerDeatilAppointmentViewController.h"
#import "FastPayTableViewController.h"

#import "UIButton+Extension.h"
#import "MYDiscountStoreViewController.h"
#import "MYLifeSecondViewController.h"
#import "MYCaiFuTongViewController.h"
#import "MYHomeCharacterTableViewController.h"
#import "MYMasterOrderViewController.h"
#import "LOLScanViewController.h"
/**
 *  根据不同控制器跳转转H5(MYHomeHospitalDeatilViewController)页面。
 依据tag:
 
 if tag = 0  医院详情
 if tag = 1  特惠详情
 if tag = 2  轮播图详情
 if tag = 3  视频详情
 if tag = 4  美容院详情
 if tag = 5  设计师招募
 
 */

@interface MYHomeHospitalDeatilViewController () <UIWebViewDelegate,UIAlertViewDelegate,LOLShareViewDelegate,RCIMConnectionStatusDelegate,RCIMUserInfoDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) UIWebView *webView;
@property(strong,nonatomic) UIButton * backbtn;

@property(assign,nonatomic) CGFloat lat;//维度
@property(assign,nonatomic) CGFloat  lon;//经度

@property(assign,nonatomic) int  disc;  //医院的距离
@property(assign,nonatomic) int  dic;  //美容院距离

@property(strong,nonatomic) NSString * disct;

@property(strong,nonatomic) NSString * discount;

@property(strong,nonatomic) NSString * doctorkefuID;

@property (nonatomic, assign) NSInteger index;

@property (strong, nonatomic) NSString *titlename;

@property(strong,nonatomic) NSString * webviewtitleName;
@property(strong,nonatomic) NSString * webviewcurrentURL;
@property (copy, nonatomic) NSString *webviewcurrentImage;

/**当前页面的url*/
@property (copy, nonatomic) NSString *currentURL;
/**当前页面的标题*/
@property (copy, nonatomic) NSString *currentTitle;
//*当前页面的第一张图片  进入到webView第二页时用到


@property(strong,nonatomic) UIButton * topview;

@property(strong,nonatomic) NSString * ProductID;

//@property(strong,nonatomic) MYDiscountDinggouViewController * dinggouVC;

@end

@implementation MYHomeHospitalDeatilViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:@"医院详情"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [MobClick beginLogPageView:@"医院详情"];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

//    self.titleName = nil;
//    self.imageName = nil;
    
    // 计算距离
    self.lat =  [[MYUserDefaults objectForKey:@"latitude"]  floatValue]  ;
    self.lon =  [[MYUserDefaults objectForKey:@"longitude"]  floatValue]  ;
    
    if(self.lat == 0)
    {
        self.discount = @"0";
        self.disct = @"未知";
    }
    else{
        self.discount = @"1";
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude: self.lat longitude:self.lon];
        
        double str11 = self.latitude;
        double str22 = self.longitude;
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:str11 longitude:str22];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        double distance = meters/1000;
        self.disc = (int )distance;
        self.dic = (int)distance;
    }
    
    [self loadWebView];

    [self setupNav];
    
    
//    置顶控件
    [self addGotoTopView];
}

//置顶控件
-(void)addGotoTopView
{
    UIButton *topview = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW-60, MYScreenH - 90, 40, 40)];
    self.topview = topview;
    [self.view addSubview:topview];
    [topview setImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
    [topview addTarget:self action:@selector(clickTopbtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTopbtn
{
    
    if ([self.webView subviews]) {
        
        UIScrollView* scrollView = [[self.webView subviews] objectAtIndex:0];
        
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    
}

- (void)setupUI
{
    // 分享的文字
    if (self.titleName == nil || [self.titleName isEqualToString:@""]||[self.titleName isEqualToString:@"魔颜网最强推荐"]) {
        
//        self.titleName = @"魔颜网最强推荐";
        //self.titlename = self.currentTitle;
        self.titleName = self.webviewtitleName;

    }else{
        
        if (self.index) {
            
        }else
        {
            
            self.titleName = [NSString stringWithFormat:@"%@",self.titleName];
        }
        
    }
    
}

/**导航条上的分享和返回*/
- (void)setupNav
{
    //添加返回按钮
    UIImageView *imageView = [UIImageView addImaViewWithFrame:CGRectMake(15, 30, 12, 18) imageName:@"back"];
    [self.view addSubview:imageView];
    
    self.backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backbtn.frame = CGRectMake(kMargin, MYMargin, 40, 40);
    [self.backbtn addTarget:self action:@selector(clickBackbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backbtn];
    
    
    if ([WXApi isWXAppInstalled]) {
        
        if (self.tag != 3) { /**视频暂时不让分享*/
            
            UIImageView *imgView = [UIImageView addImaViewWithFrame:CGRectMake(MYScreenW - 36, 32, 18, 18) imageName:@"share"];
            [self.view addSubview:imgView];
            
            //分享按钮
            UIButton *shareBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 50, 20, 50, 50) image:nil highImage:nil backgroundColor:nil Target:self action:@selector(sharedBtnClick)];
            [self.view addSubview:shareBtn];
        }
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
}

//加载网页A
- (void)loadWebView
{
    UIWebView *webview = [[UIWebView alloc]init];
    webview.delegate = self;
    self.webView = webview;
    webview.backgroundColor = [UIColor whiteColor];
    webview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH );
    [webview setScalesPageToFit:YES];
    [self.view addSubview:webview];
    webview.userInteractionEnabled = YES;
    


    
    /**医院详情*/
    if (self.tag == 0) {
        
        
        if ([self.discount isEqualToString:@"0"]) {
            self.url = [NSString stringWithFormat:@"%@hospital/queryHospitalInfoIndex?id=%@",kOuternet1,self.id];
        }else{
            self.url = [NSString stringWithFormat:@"%@hospital/queryHospitalInfoIndex?id=%@&disc=%d",kOuternet1,self.id,self.disc];
        }
    }
    
    /**特惠详情*/
    if (self.tag == 1) {
        if ([self.classify isEqualToString:@"2"]) {

            self.url = [NSString stringWithFormat:@"%@/newSalonSpe/querySalonNewSpeIndex?id=%@",kOuternet1,self.id];
        }else
        {
            self.url = [NSString stringWithFormat:@"%@specialdeals/querySpecialdealsIndex?id=%@",kOuternet1,self.id];
        }
        
    }
     //美容院
    if(self.tag == 4)
    {
        if ([self.discount isEqualToString:@"0"] || self.discount ==nil) {
            
            self.url = [NSString stringWithFormat:@"%@salon/querySalonInfoIndex?id=%@&dic=%@",kOuternet1,self.id,@"-1"];
        }else{
            
            self.url = [NSString stringWithFormat:@"%@salon/querySalonInfoIndex?id=%@&dic=%d",kOuternet1,self.id,self.dic];
        }
    }
//    新版美容院
    if (self.tag == 5) {
        
        if ([self.discount isEqualToString:@"0"] || self.discount ==nil) {
            
            self.url = [NSString stringWithFormat:@"%@/newSalon/queryNewSalonInfoIndex?id=%@&dic=%@",kOuternet1,self.id,@"-1"];
        }else{
            
            self.url = [NSString stringWithFormat:@"%@/newSalon/queryNewSalonInfoIndex?id=%@&dic=%d",kOuternet1,self.id,self.dic];
        }
    }
    
//    美容院活动页
    if (self.tag == 6) {
        
        self.url = [NSString stringWithFormat:@"%@/newSalonSpe/querySalonNewSpeIndex?id=%@",kOuternet1,self.id];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    
}

/**
 @breif 与js交互
 */
- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"myapp"] )
    {
        NSString *type = [url host];
        
        if ([type isEqualToString:@"hospital"])
        {
            
            MYHomeDoctorTableViewController *doctorVC = [[MYHomeDoctorTableViewController alloc] init];
            doctorVC.hospitalId = [url query];
            [self.navigationController pushViewController:doctorVC animated:YES];
            
        }else if ([type isEqualToString:@"totalSale"])
        {
            
            MYHomeDiscountListTableViewController *discountVC = [[MYHomeDiscountListTableViewController alloc] init];
            discountVC.hospitalId = [url query];
            [self.navigationController pushViewController:discountVC animated:YES];
            
        }else if ([type isEqualToString:@"buy"])
        {
           
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0] substringFromIndex:11];
            NSString *str2 = [array[1] substringFromIndex:3];
            NSString *str3 = [array[2] substringFromIndex:14];
            NSString *str4 = [array[3] substringFromIndex:5];
            NSString *str5 = [array[4] substringFromIndex:5];
            NSString *str6 = [array[5] substringFromIndex:6];
            
            NSString *str7 = [str5 stringByAppendingString:str6];
            NSString *string = [str7 stringByRemovingPercentEncoding];
            NSString *jigoustr = [str5 stringByRemovingPercentEncoding];
            
          
            self.ProductID = str2;
          
            if (MYAppDelegate.isLogin) {

                NSMutableDictionary *param = [NSMutableDictionary dictionary];

                param[@"specialdealsId"] = self.ProductID;
                param[@"ver"] = MYVersion;
                param[@"userId"] = [MYUserDefaults objectForKey:@"id"];

                NSString *url;
                if (array.count >6) {
                    url = [NSString stringWithFormat:@"%@/salonSpe/queryUserDiscount",kOuternet1];

                }else{

                    url = [NSString stringWithFormat:@"%@/specialdeals/queryUserDiscount",kOuternet1];
                }
                
                [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@",url] params:param success:^(id responseObject) {
                    
                    
                    if ([responseObject[@"status"] isEqualToString:@"success"]) {
                        
                        if ([responseObject[@"isDiscount"] isEqualToString:@"1"]) // 打折
                        {
                            MYMasterOrderViewController * dinggouVC = [[MYMasterOrderViewController alloc]init];
                            NSString *lablestr ;
                            NSString *number;
                            if (array.count > 6) {
                                
                                dinggouVC.Vctage = @"1";
                                
                                lablestr = [array[6] substringFromIndex:6];
                                number = @"1";
                                
                            }else{
                                
                                dinggouVC.Vctage = @"0";
                            }

                            dinggouVC.hospotalId = str1;
                            dinggouVC.id = str2;
                            dinggouVC.yuyuejia = str3;
                            dinggouVC.dingjin = str4;
                            dinggouVC.qianggoutitle = string;
                            dinggouVC.jigoustr = jigoustr;
                            dinggouVC.LABLE = lablestr;
                            dinggouVC.depict = responseObject[@"depict"];
                            dinggouVC.bindDiscount = responseObject[@"bindDiscount"];
                            dinggouVC.number = number;
                            [self.navigationController pushViewController:dinggouVC animated:YES];
                            
                        }else // 不打折
                        {
                            MYDiscountDinggouViewController*dinggouVC = [[MYDiscountDinggouViewController alloc] init];

                            NSString *lablestr ;
                            if (array.count > 6) {
                                
                                dinggouVC.Vctage = @"1";
                                lablestr = [array[6] substringFromIndex:6];
                                
                            }else{
                                
                                dinggouVC.Vctage = @"0";
                            }
                            dinggouVC.hospotalId = str1;
                            dinggouVC.id = str2;
                            dinggouVC.yuyuejia = str3;
                            dinggouVC.dingjin = str4;
                            dinggouVC.qianggoutitle = string;
                            dinggouVC.jigoustr = jigoustr;
                            dinggouVC.LABLE = lablestr;
                            
                            [self.navigationController pushViewController:dinggouVC animated:YES];
                        }
                    }
                    if ([responseObject[@"status"] isEqualToString:@"-110"]) {
                        
                        [MBProgressHUD showError:@"请登录后重试"];
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
        
            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
                
            }
            
        }else if([type isEqualToString:@"Appoint"])                 //名医预约
        {
            
            MYHomeDesignerDeatilAppointmentViewController *DesigerAppiontmentVC = [[MYHomeDesignerDeatilAppointmentViewController alloc]init];
            
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0] substringFromIndex:5];
            NSString *str2 = [array[1] substringFromIndex:6];
            NSString *str3 = [str1 stringByRemovingPercentEncoding];
            
            DesigerAppiontmentVC.name = str3;
            DesigerAppiontmentVC.desigerPrice = str2;
            
            if (MYAppDelegate.isLogin) {
                [self.navigationController pushViewController:DesigerAppiontmentVC animated:YES];
            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }else if([type isEqualToString:@"kefu"])                //名医客服
        {
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0]  substringFromIndex:5];
            NSString *namestr = [str1 stringByRemovingPercentEncoding];
            
            [self loadKeFuId];
            
            if (MYAppDelegate.isLogin) {
                [self PushKeFuVC:namestr];
            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }else if([type isEqualToString:@"salon"])    //后支付
        {

            NSString *str = [url query];
            NSArray  *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0]  substringFromIndex:5];
            NSString *namestr = [str1 stringByRemovingPercentEncoding];
            NSString *str2 = [array[1] substringFromIndex:5];
            NSString *str3 = [array[2] substringFromIndex:7];
            NSString *IDstr = [array[3] substringFromIndex:3];

            NSString *status;
            if (self.tag == 0) {
                status = [array[4] substringFromIndex:7];
            }else{
            
            }
            
            FastPayTableViewController *fastVC = [[FastPayTableViewController alloc]init];
            fastVC.vctittle = namestr;
            fastVC.youhuiPrice = str2;
            fastVC.discountPrice = str3;
            fastVC.solanID = IDstr;
            fastVC.Vctag = status;
            
            if (MYAppDelegate.isLogin) {
                
                [self.navigationController pushViewController:fastVC animated:YES];
                
            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }else if([type isEqualToString:@"list"])
        {
            
            MYDiscountStoreViewController *lifeVC = [[MYDiscountStoreViewController alloc]init];
            lifeVC.scrollPoint = MYScreenW;
            lifeVC.TAG = @"1";
            [self.navigationController pushViewController:lifeVC animated:YES];
            
        }else if([type isEqualToString:@"generalPay"]) //财付通付款页面
        {
            NSString *str = [url query];
            NSArray  *array = [str componentsSeparatedByString:@"?"];
            NSString *price = [array[0] substringFromIndex:6];
            NSString *id = [array[1] substringFromIndex:3];
            NSString *name = [array[2] substringFromIndex:5];
            NSString *namestr = [name stringByRemovingPercentEncoding];
            
            MYCaiFuTongViewController *caifutongVC = [[MYCaiFuTongViewController alloc]init];
            caifutongVC.solanID = id;
            caifutongVC.price = price;
            caifutongVC.titlestr = namestr;
            
            if (MYAppDelegate.isLogin) {
                
                [self.navigationController pushViewController:caifutongVC animated:YES];

            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }

        }else if([type isEqualToString:@"secondLife"])
        {
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *id = [array[0] substringFromIndex:5];
            NSString *name = [array[1] substringFromIndex:9];
            NSString *typeName = [name stringByRemovingPercentEncoding];
            
            MYLifeSecondViewController *secondVC = [[MYLifeSecondViewController alloc] init];
            secondVC.type = id;
            secondVC.titlename = typeName;
            [self.navigationController pushViewController:secondVC animated:YES];
         }else if([type isEqualToString:@"doctor"])
        {

            MYHomeDoctorDeatilTableViewController *doctorDetailVC = [[MYHomeDoctorDeatilTableViewController alloc] init];
            doctorDetailVC.id = [url query];
            doctorDetailVC.hospitalId = [[url path] substringFromIndex:1];
            [self.navigationController pushViewController:doctorDetailVC animated:YES];
        }
        
        [self.webView stopLoading];
        
        return NO;
    }
    return YES;
}

/**
 *  返回
 */
-(void)clickBackbtn
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
           
            if ([controller isKindOfClass:[LOLScanViewController class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
        
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
 @brief 分享
 */
-(void)sharedBtnClick
{
    if (MYAppDelegate.isLogin)
    {
        //分享的图片
        UIImage *image;
        if(self.imageName){
            
            if ([self.imageName hasPrefix:@"http://"]) {
                
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageName]]];
            }else{
                
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,self.imageName]]]];
            }
          }else{
            
              image = [UIImage imageNamed:@"icon1"];
          }
        
        LOLShareView *shareView = [[LOLShareView alloc] init];
        shareView.delegate = self;
        if (self.titleName==nil) {
            self.titleName = self.webviewtitleName;
        }
        [shareView startShareWithText:self.titleName image:image];
        self.index = 1;
        
    }else
    {
        [UIAlertViewTool showAlertView:self title:nil message:@"您还未登录,去登录" cancelTitle:@"取消" otherTitle:@"确定" cancelBlock:^{
            
        } confrimBlock:^{
            
            MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }
    
}

//分享
- (void)shareViewDidClickShareBtn:(LOLShareView *)shareView selBtn:(LOLShareBtn *)shareBtn
{
    [[UMSocialControllerService defaultControllerService] setShareText:shareView.shareText shareImage:shareView.shareImage socialUIDelegate:nil];
    
    if ((shareBtn.socalSnsType == UMSocialSnsTypeWechatTimeline) || (shareBtn.socalSnsType == UMSocialSnsTypeWechatSession) || (shareBtn.socalSnsType == UMSocialSnsTypeMobileQQ)) {
        if ((shareView.shareImage != nil) && (shareView.shareText != nil)) {
        
            if (self.currentURL !=nil) {
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"魔颜网";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"魔颜网";                [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@&qrc=1",self.currentURL];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@&qrc=1",self.currentURL];
                //            [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@&qrc=1",self.currentURL];

            }else
            {
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"魔颜网";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"魔颜网";
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@&qrc=1",self.webviewcurrentURL];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@&qrc=1",self.webviewcurrentURL];
                
            }
        }
        else
        {
         
                [MBProgressHUD showError:@"分享失败,请稍候重试"];
                return;
        }
    }
    
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformString:(shareBtn.socalSnsType)]];
    
    platform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}

//获取客服ID
-(void)loadKeFuId
{
    AFHTTPRequestOperationManager *KeFuIdmager = [[ AFHTTPRequestOperationManager alloc]init];
    
    [KeFuIdmager GET:[NSString stringWithFormat:@"%@/kefu/serverId",kOuternet1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            self.doctorkefuID = responseObject[@"kefu_id"];
            
        }else{
            
            [MBProgressHUD showError:@"请稍后联系"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

// 咨询客服
-(void)PushKeFuVC:(NSString *)name
{
    //和容云断开链接 以便再次连接
    [[RCIMClient sharedRCIMClient] disconnect:YES];
    
    AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (deleate.isLogin) {
        NSString *token = [MYUserDefaults objectForKey:@"token"];
        //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                //   跳转客服
                RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
                
                [conversationVC.view removeFromSuperview];
                conversationVC.conversationType = ConversationType_APPSERVICE;
                conversationVC.targetId = self.doctorkefuID;//KEFU144945814920827
                conversationVC.userName = name;
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


/**
 *  @param webView <#webView description#>
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    
    
    self.webviewtitleName = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.webviewcurrentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    self.webviewcurrentImage = [webView stringByEvaluatingJavaScriptFromString: @"document.getElementsByTagName(\"img\")[0].src"];
//    
//    MYLog(@"\n当前页面的URL:%@\n当前页面的title:%@\n当前页面的第一张图片:%@",self.webviewcurrentURL,self.webviewtitleName,self.webviewcurrentImage);
    
    [self setupUI];

    
    
}

@end
