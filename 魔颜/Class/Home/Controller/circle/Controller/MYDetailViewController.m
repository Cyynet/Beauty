//
//  MYDetailViewController.m
//  魔颜
//
//  Created by admin on 16/1/21.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYDetailViewController.h"
#import "MYTieziModel.h"
#import "MYCircleComment.h"
#import "MYCommentCell.h"
#import "MYCircleCommentHeadView.h"
#import "MYCircleBtn.h"
#import "MYTextView.h"
#import "MYTieziModel.h"

#import "MYDiscountListModel.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "UILabel+Extension.h"
#import "UIButton+Extension.h"

#define headWebHeight 80.0f
#define interval 10.0f

@interface MYDetailViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

/** 导航条的背景view */
@property (nonatomic, strong) UIView  *navView;
/** 返回按钮 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;

@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, assign) CGRect imgRect;
@property (nonatomic, assign) CGFloat previousY;
/**点赞小图片数组*/
@property (strong, nonatomic) NSMutableArray *picArr;
/**评论数组*/
@property (strong, nonatomic) NSArray *circleArr;

@property (strong, nonatomic) UITableView *circleTableView;

/**图片*/
@property (copy, nonatomic) NSString *pic;
@property (weak, nonatomic) UITextView *placeholder;
@property (strong, nonatomic) MYTextView *textView;
//@property (weak, nonatomic) UIButton *coverView;
@property (weak, nonatomic) UIView  *commentView;
@property (weak, nonatomic) UIButton *praseBtn;
@property (weak, nonatomic) UIButton *commentBtn;

@property (copy, nonatomic) NSString *focus;
@property(assign,nonatomic) int  praiseStatus;    //点赞状态
@property(assign,nonatomic) int  focusStauts;    //收藏

@property(weak,nonatomic) UIButton * praiseBtn;
@property(strong,nonatomic) MYCircleBtn * sendBtn;

/** 帖子模型 */
@property (strong, nonatomic)  MYTieziModel *tieZiModel;
@end

//顶部scrollHeadView 的高度,先给写死
static const CGFloat ScrollHeadViewHeight = 210;

@implementation MYDetailViewController

- (NSMutableArray *)picArr
{
    if (!_picArr) {
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

- (NSArray *)circleArr
{
    if (!_circleArr) {
        _circleArr = [NSArray array];
    }
    return _circleArr;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"帖子详情"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"帖子详情"];
    
    //隐藏系统的导航条，由于需要自定义的动画，自定义一个view来代替导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化界面
    [self setUI];
    
    //初始化导航条上的内容
    [self setUpNavigtionBar];
    
    [self loadDetailHeadData];
    [self loadDetailBodyData];
    
}
- (void)setUI
{
    //将view的自动添加scroll的内容偏移关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark - ************* 添加tableView ************
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.sectionFooterHeight = 0;
    self.circleTableView = tableView;
    
    UIWebView *webview = [[UIWebView alloc]init];
    webview.delegate = self;
    webview.scrollView.scrollEnabled = NO;
    self.webView = webview;
    webview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH);
    [self.circleTableView setTableHeaderView:self.webView];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -110, MYScreenW, ScrollHeadViewHeight)];
    
    //    http://img.chengmi.com/cm/3bc2198c-c909-4698-91b2-88e00c5dff2a
    
    self.imgRect = imgView.frame;
    self.imgView  =imgView;
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    [self.circleTableView insertSubview:imgView atIndex:0];
    self.previousY = -imgView.size.height;
    self.circleTableView.contentInset = UIEdgeInsetsMake(imgView.height, 0, 0, 0);
    
    
    /** 添加底部控件 */
    [self setupBoomView];
    
}

//初始化导航条上的内容
- (void)setUpNavigtionBar
{
    //初始化山寨导航条
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, 64)];
    self.navView.backgroundColor = MYColor(231, 231, 231);
    self.navView.alpha = 0.0;
    [self.view addSubview:self.navView];
    
    //添加返回按钮
    UIImageView *imageView = [UIImageView addImaViewWithFrame:CGRectMake(15, 32, 12, 18) imageName:@"back-1"];
    [self.view addSubview:imageView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(kMargin, MYMargin, 40, 40);
    [self.backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
}
//返回上个控制器
- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  请求数据
 */
- (void)loadDetailHeadData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [UIColor clearColor];
    hud.alpha = 0.8;
    hud.activityIndicatorColor = UIColorFromRGB(0xbcaa7c);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    param[@"ver"] = MYVersion;
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/queryDiary",kOuternet2] params:param success:^(id responseObject) {
        
        hud.hidden = YES;
        MYGlobalGCD((^{
            /**
             *  文章文字和标题
             */
            self.tieZiModel = [MYTieziModel objectWithKeyValues:responseObject[@"diaryList"][@"diary"]];
            //     self.content = responseObject[@"diaryList"][@"diary"][@"content"];
            
            /**
             *  文章文字
             */
            self.pic = responseObject[@"diaryList"][@"diary"][@"pic"];
            
            /**
             *  帖子收藏
             */
            self.focusStauts = [responseObject[@"diaryList"][@"focusStatus"] intValue];
            if (self.focusStauts) {
                self.focus = @"已收藏";
            }else{
                self.focus = @"收藏";
            }
            
            MYMainGCD((^{
                [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,self.tieZiModel.homePagePic]]];
                [self showInWebView];
            }));
            
        }));
    } failure:^(NSError *error) {
        
        hud.hidden = YES;
        
    }];
    
}
- (void)loadDetailBodyData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    param[@"ver"] = MYVersion;
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/queryDiary",kOuternet1] params:param success:^(id responseObject) {
        
        MYGlobalGCD((^{

            /**
             *  点赞状态
             */
            self.praiseStatus = [responseObject[@"diaryList"][@"praiseStatus"] intValue];
            
            /**
             *  帖子评论回复数据
             */
            self.circleArr  = [MYCircleComment objectArrayWithKeyValuesArray:responseObject[@"diaryList"][@"diaryCommentsList"]];
            
            MYMainGCD(^{
                
                [self.circleTableView reloadData];
                if (self.praiseStatus == 0) {
                    [_praiseBtn setBackgroundImage:[UIImage imageNamed:@"prase_normal"] forState:UIControlStateNormal];
                }else{
                    [_praiseBtn setBackgroundImage:[UIImage imageNamed:@"prase_press"] forState:UIControlStateNormal];
                }

                
            });
        
                }));
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - *********** 拼接html语言
- (void)showInWebView
{
    NSString *html = [NSString stringWithFormat:@"<html><head><meta name = 'format-detection' content = 'telephone=no'><link rel=\"stylesheet\" href=\"%@\"></head><body>%@</body></html>",[[NSBundle mainBundle] URLForResource:@"MYDetails.css" withExtension:nil],[self touchBody]];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"eye@2x.png" ofType:nil];
    
    
    [body appendFormat:@"<div class=\"user\">"
     "<div class=\"user_left\">"
     "<img src=\"%@%@\">  <p>%@</p>"
     "</div>"
     "<div class=\"user_right\">"
     "<img src=\"%@\">"
     "<span id='focus' onclick='guanzhu()'>%@</span>"
     
     "<p>%@</p>"
     "</div>"
     "</div>",
     kOuternet1,self.tieZiModel.userPic,self.tieZiModel.userName,imagePath,self.focus,self.tieZiModel.pageView];
    
    
    [body appendFormat:@"<div class=\"title\">【 %@ 】</div>",self.tieZiModel.title];
    
    
    // 遍历文字
    self.tieZiModel.content = [NSString stringWithFormat:@"<div class=\"content\">#%@</div>",self.tieZiModel.content];
    NSArray *arr = [self.tieZiModel.content componentsSeparatedByString:@"#"];
    NSString *text;
    
    for (int i = 0; i < arr.count; i ++) {
        
        if (i < arr.count - 1) {
            
            if (i >= 10) {
                text = [NSString stringWithFormat:@"%@#*%d",arr[i],i];
            }else{
                text = [NSString stringWithFormat:@"%@#%d",arr[i],i];
            }
        }else{
            text = arr[i];
        }
        
        [body appendString:text];
    }
    
    // 遍历img
    NSArray *picArr = [self.pic componentsSeparatedByString:@","];
    
    for (int i = 0; i < picArr.count; i ++) {
        
        NSString *URL = [NSString stringWithFormat:@"%@%@",kOuternet1,picArr[i]];
        
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\" >"];
        [imgHtml appendFormat:@"</div><img src=\"%@\"><div class=\"content\">",URL];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        
        if (i >= 10) {
            [body replaceOccurrencesOfString:[NSString stringWithFormat:@"#*%d",i] withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        }else{
            
            // 替换标记
            [body replaceOccurrencesOfString:[NSString stringWithFormat:@"#%d",i] withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        }
    }
    
    [body appendFormat:@"<script>"
     
     "function guanzhu(type){"
     
     "window.location.href = 'focus://'+type;}"
     
     "function afterguanzhu(text){"
     
     "document.getElementById(\"focus\").innerHTML=text;}"
     
     "</script>"];
    
    return body;
}

#pragma mark - ************* tableViewDelegate *************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.circleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MYCircleComment *comment = self.circleArr[section];
    return comment.replyVOs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYCommentCell *cell = [MYCommentCell cellWithTableView:tableView indexPath:indexPath];
    MYCircleComment *comment = self.circleArr[indexPath.section];
        
    cell.hostName = comment.diaryComments.userName;
    MYCircleReply *reply = comment.replyVOs[indexPath.row];
    cell.reply = reply;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 代理方法
// 当一个分组标题进入视野的时候就会调用该方法
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //创建自定义的头部视图
    MYCircleCommentHeadView *headerview=[MYCircleCommentHeadView headerWithTableView:tableView section:section];

    
    headerview.headBlock = ^(NSString *name){
        self.textView.placeHoledr = [NSString stringWithFormat:@"回复了 %@",name];
        [self.textView becomeFirstResponder];
        MYCircleComment *comment = self.circleArr[section];
        self.sendBtn.tag = section;
        self.sendBtn.ID = comment.diaryComments.id;
    };
    
    if (!(self.circleArr.count == 0)) {
        MYCircleComment *comment = self.circleArr[section];
        headerview.comment = comment;
        return headerview;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MYCircleCommentHeadView *view = (MYCircleCommentHeadView *)[self tableView:self.circleTableView viewForHeaderInSection:section];
    return view.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MYCircleComment *comment = self.circleArr[indexPath.section];
    if (comment.replyVOs.count) {
        UITableViewCell *cell = [self tableView:self.circleTableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else{
        return 1;
    }

  
    
}

#pragma mark - UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"focus"]) {
        
        [self getFocusData];
        
    }
    
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat titleW = MYScreenW - 50;
    UILabel *titleLabel = [UILabel addLabelWithFrame:CGRectMake((MYScreenW - titleW)/ 2, 20, titleW, 44) title:self.tieZiModel.title titleColor:titlecolor font:[UIFont boldSystemFontOfSize:17]];
    self.titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(0,0, MYScreenW, height);
    self.circleTableView.tableHeaderView = webView;
    [self.circleTableView reloadData];
    
    [self.circleTableView setContentOffset:CGPointMake(0, -ScrollHeadViewHeight) animated:YES];
    
    
}

/**
 *  功能部分
 */
//退出的时候调用 放弃接受通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ******** 回复楼主 *******
- (void)jumpToSubView:(MYCircleBtn *)btn
{
    
    if([self.textView.text isEqualToString:@""])
    {
        [MBProgressHUD showHUDWithTitle:@"请输入评论内容" andImage:nil andTime:1.0];
    }else{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"commentId"] = @(btn.ID);
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    param[@"signature"] = [MYStringFilterTool getSignature];
    param[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    param[@"content"] = _textView.text;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/diary/replayDiary",kOuternet1] params:param success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            [MBProgressHUD showHUDWithTitle:@"发送成功" andImage:nil andTime:1.0];
            [self clickDismissBtn];
            [self loadDetailBodyData];
            
        }else{
            [MBProgressHUD showHUDWithTitle:@"操作失败" andImage:nil andTime:1.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"操作失败"];
    }];
    }
}

// brief 点赞/取消点赞 对评论的点赞
- (void)clickPraseBtn:(MYCircleBtn *)btn
{
    
    if (!MYAppDelegate.isLogin) {
        
        [MBProgressHUD showError:@"您还未登陆，请先登陆"];
        
    }else{
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"commentId"] = @(btn.ID);
        param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        param[@"signature"] = [MYStringFilterTool getSignature];
        param[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        
        if (btn.selected) {
            [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/cancelPraiseComment",kOuternet1] params:param success:^(id responseObject) {
                
                if ([responseObject[@"status"] isEqualToString:@"success"]) {
                    
                    [self CricletableData:btn];
                    
                }else{
                    [MBProgressHUD showSuccess:@"操作失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showSuccess:@"操作失败"];
                
            }];
            
        }else{
            
            [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/diary/praiseComment",kOuternet1] params:param success:^(id responseObject) {
                
                if ([responseObject[@"status"] isEqualToString:@"success"]) {
                    
                    [self CricletableData:btn];
                    
                }else{
                    [MBProgressHUD showSuccess:@"操作失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showSuccess:@"操作失败"];
                
            }];
        }
        
    }
}

//底部菜单
-(void)setupBoomView
{
    UIView *boomview = [[UIView alloc]initWithFrame:CGRectMake(0, MYScreenH - 50, MYScreenW, 50)];
    boomview.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:boomview];
    self.commentView = boomview;
    
    
    //输入内容视图
    MYTextView *textView = [[MYTextView alloc] initWithFrame:CGRectMake(kMargin, 10, MYScreenW * 0.7, 30)];
    // 滚动textView,出发方法，里面退下键盘
    textView.delegate = self;
    textView.placeHoledr = @"别拦我，让我说句话";
    self.textView = textView;
    [self.commentView addSubview:textView];
    
    //发送按钮
    MYCircleBtn *sendBtn = [[MYCircleBtn alloc] initWithFrame:CGRectMake(textView.right + 8, kMargin, 60, 30)];
    [sendBtn setTitle:@"发布评论"];
    [sendBtn addTarget:self action:@selector(clicksendMessageBtn:)];
    self.sendBtn = sendBtn;
    sendBtn.tag = - 1;
    [self.commentView addSubview:sendBtn];
    
    //点赞按钮
    UIButton *praiseBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 40, kMargin, 30, 30) backgroundColor:nil Target:self action:@selector(ClickDianzanBtn)];
    self.praiseBtn = praiseBtn;
    [boomview addSubview:praiseBtn];
    
    

        // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:textView];
    
    
    // 监听键盘的弹出的隐藏
    // 监听键盘弹出和退下
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
// 监听textView文字改变，改变发送按钮的状态
-(void)textChange
{
    self.sendBtn.enabled = self.textView.text.length!= 0;
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    
    // 取出键盘弹出的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取出键盘高度
    CGRect keyBoardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.commentView.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight );
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    // 取出键盘隐藏的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 清空transform
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.commentView.transform = CGAffineTransformIdentity;
//        self.textView.placeHoledr = @"别拦我,让我说句话";
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)clickDismissBtn
{
    [UIView animateWithDuration:1.0 animations:^{
    
        [self.textView resignFirstResponder];
        self.textView.text = nil;
        self.textView.placeHoledr = @"别拦我，让我说句话";

    }];
    
}

#pragma ---->>>>>>>请求点赞数据<<<<<<<-------
-(void)CricletableData:(MYCircleBtn *)btn
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/queryDiary",kOuternet1] params:param success:^(id responseObject) {
        
        //尾部
        self.circleArr  = [MYCircleComment objectArrayWithKeyValuesArray:responseObject[@"diaryList"][@"diaryCommentsList"]];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:btn.tag];
        [self.circleTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        
    }];
    
}
/**请求收藏数据*/
-(void)getFocusData
{
    if (!MYAppDelegate.isLogin) {
        
        [MBProgressHUD showError:@"您还未登陆，请先登陆"];
        
    }else{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        params[@"type"] = @"0";
        params[@"attentionId"] = self.id;
        params[@"signature"] = [MYStringFilterTool getSignature];
        params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        
        if (self.focusStauts == 0){
            
            /**收藏*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/focusDiary",kOuternet1] params:params success:^(id responseObject) {
                
                self.focusStauts = 1;
                [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:afterguanzhu(\'已收藏\')"];
                
            } failure:^(NSError *error) {}];
            
        }else{
            
            /**取消收藏*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/cancelFocusDiary",kOuternet1] params:params success:^(id responseObject) {
                self.focusStauts = 0;
                [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:afterguanzhu(\'收藏\')"];
                
            } failure:^(NSError *error) {}];}
        
    }
    
    
}
/**对帖子的点赞*/
-(void)ClickDianzanBtn
{
    if (!MYAppDelegate.isLogin) {
        
        [MBProgressHUD showError:@"您还未登陆，请先登陆"];
        
    }else{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        params[@"diaryId"] = self.id;
        params[@"signature"] = [MYStringFilterTool getSignature];
        params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        if (self.praiseStatus == 0){
            
            /**点赞*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@//diary/praiseDiary",kOuternet1] params:params success:^(id responseObject) {
                
                self.praiseStatus = 1;
                [self.praiseBtn setTitle:@"已赞" forState:UIControlStateNormal];
                [_praiseBtn setImage:[UIImage imageNamed:@"prase_press"] forState:UIControlStateNormal];
                
                
            } failure:^(NSError *error) {}];
            
        }else{
            
            /**取消点赞*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/cancelPraiseDiary",kOuternet1] params:params success:^(id responseObject) {
                self.praiseStatus = 0;
                [self.praiseBtn setTitle:@"点赞" forState:UIControlStateNormal];
                [_praiseBtn setImage:[UIImage imageNamed:@"prase_normal"] forState:UIControlStateNormal];
                
            } failure:^(NSError *error) {}];}
        
    }
    
}
//  底部对原帖子对回复
-(void)clicksendMessageBtn:(MYCircleBtn *)btn
{
    if (!MYAppDelegate.isLogin) {
        
        [MBProgressHUD showError:@"您还未登陆，请先登陆"];
        
    }else{
        
        if (btn.tag != -1) {
            [self jumpToSubView:btn];
        }else{
            
            if([self.textView.text isEqualToString:@""])
            {
                [MBProgressHUD showHUDWithTitle:@"请输入评论内容" andImage:nil andTime:1.0];
            }else{
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
                params[@"type"] = 0;
                params[@"diaryId"] = self.id;
                params[@"content"] = _textView.text;
                params[@"signature"] = [MYStringFilterTool getSignature];
                params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
                
                [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/diary/commentDiary",kOuternet1] params:params success:^(id responseObject) {
                    if ([responseObject[@"status"] isEqualToString: @"success"])
                    {
                        [MBProgressHUD showSuccess:@"发帖成功"];
                        
                        [self clickDismissBtn];
                        //重新刷新数据
                        [self loadDetailBodyData];
                        self.sendBtn.tag = -1;
                    }else
                    {
                        [MBProgressHUD showError:@"发帖失败"];
                    }
                }
                 
                    failure:^(NSError *error) {
                    }];
}
        }
        
    }
    
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //记录出上一次滑动的距离，因为是在tableView的contentInset中偏移的ScrollHeadViewHeight，所以都得加回来
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //根据偏移量算出alpha的值,渐隐,当偏移量大于-180开始计算消失的值
    CGFloat startF = -180;
    //初始的偏移量Y值为 顶部控件的高度
    CGFloat initY = ScrollHeadViewHeight;
    //缺少的那一段渐变Y值
    CGFloat lackY = initY + startF;
    //自定义导航条高度
    CGFloat naviH = 64;
    
    //渐现alph值
    CGFloat alphaScaleShow = (offsetY + initY - lackY) /  (initY - naviH - lackY) ;
    
    if (alphaScaleShow >= 0.98) {
        //显示导航条
        [UIView animateWithDuration:0.04 animations:^{
            self.navView.alpha = 1;
        }];
    } else {
        self.navView.alpha = 0;
    }
    self.navView.alpha = alphaScaleShow * 0.5;
    
    
    // 往上下滚动
    if (offsetY > -ScrollHeadViewHeight && offsetY<0) {
        if (self.imgView.height > self.imgRect.size.height) {
            self.imgView.y = - self.imgRect.size.height;
            self.imgView.height = self.imgRect.size.height;
            self.previousY = -self.imgRect.size.height;
        }
        self.imgView.y += (offsetY - self.previousY) * 0.5;
        self.previousY = offsetY;
        return;
    }else  if(offsetY <= -self.imgRect.size.height){
        
        if (self.imgView.y > - self.imgRect.size.height) {
            self.imgView.y =  - self.imgRect.size.height;
            
            self.previousY = -self.imgRect.size.height;
        }
        CGFloat sss = (self.previousY - offsetY);
        self.imgView.y  -= sss;
        self.imgView.height +=  sss ;
        self.previousY = offsetY;
        
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
}

// 将要拖拽的时候调一次
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commentView endEditing:YES];
    //    [self clickDismissBtn];
}


@end
