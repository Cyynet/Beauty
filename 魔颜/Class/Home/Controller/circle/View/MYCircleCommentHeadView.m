//
//  MYCircleCommentHeadView.m
//  魔颜
//
//  Created by Meiyue on 15/10/31.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYCircleCommentHeadView.h"
#import "UIButton+Extension.h"

@interface MYCircleCommentHeadView ()

/*
 @brief 评论
 */
@property(weak, nonatomic) UIImageView *iconView;
@property(weak, nonatomic) UILabel *nameLabel;
@property(weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic) UILabel *textLab;
@property (weak, nonatomic) UIView *view;


/** <#注释#> */
@property (weak, nonatomic) UIButton *btn;


@end

@implementation MYCircleCommentHeadView

//创建一个自定义的头部分组视图
+(instancetype)headerWithTableView:(UITableView *)tableView section:(NSInteger )section
{
    //    static NSString *indentifier = @"header";
    NSString *indentifier = [NSString stringWithFormat:@"header%ld",(long)section];
    
    //先到缓存池中去取数据
    MYCircleCommentHeadView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifier];
    
    //如果没有，则自己创建
    if (headerview == nil) {
        headerview = [[MYCircleCommentHeadView alloc]initWithReuseIdentifier:indentifier];
        
    }
    //返回一个头部视图
    return headerview;
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    //初始化父类中的构造方法
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        //用户头像
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        [self addSubview:iconView];
        
        //用户名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = leftFont;
        self.nameLabel = nameLabel;
        nameLabel.textColor = titlecolor;
        [self  addSubview:nameLabel];
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = leftFont;
        self.timeLabel = timeLabel;
        timeLabel.textColor = subTitleColor;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self  addSubview:timeLabel];
        
        //正文
        UILabel *textLab = [[UILabel alloc] init];
        textLab.font = leftFont;
        textLab.numberOfLines = 0;
        textLab.textColor = titlecolor;
        self.textLab = textLab;
        [self addSubview:textLab];
        
        
        UIButton *btn = [UIButton addButtonWithFrame:CGRectZero backgroundColor:nil Target:self action:@selector(clickHead)];
        [self.contentView addSubview:btn];
        self.btn = btn;
        
      
    }
    return self;
}

- (void)clickHead
{
    
    if (self.headBlock) {
        self.headBlock(self.nameLabel.text);
    }
    
}

- (void)setComment:(MYCircleComment *)comment
{
    [self setupStatus:comment];
    [self setupFrame];
}

- (void)setupStatus:(MYCircleComment *)comment
{
    _comment = comment;
    
    //******************评论 ********************//
    [self.iconView setHeaderWithURL:[NSString stringWithFormat:@"%@%@",kOuternet1,comment.diaryComments.userPic]];
    
    self.nameLabel.text = comment.diaryComments.userName;
    
    self.timeLabel.text = comment.diaryComments.createTime;
    
    self.textLab.text = comment.diaryComments.content;
    
}

- (void)setupFrame
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, MYScreenW, 1)];
    view.backgroundColor = MYBgColor;
    [self addSubview:view];

    self.iconView.frame = CGRectMake(kMargin, kMargin, 32, 32);
    
    // name
    CGFloat nameX = CGRectGetMaxX(self.iconView.frame) + kMargin;
    CGFloat nameY = self.iconView.y + 8;
    
    NSDictionary *dict = @{NSFontAttributeName:leftFont};
    CGSize nameSize = [self.nameLabel.text sizeWithAttributes:dict];
    self.nameLabel.frame = (CGRect){nameX,nameY,nameSize};
    
    self.timeLabel.frame = CGRectMake(MYScreenW - 150, self.nameLabel.y, 150, nameSize.height);
    
    //正文
    [self.textLab setRowSpace:5];
    CGFloat width = MYScreenW - 60;
    CGFloat height = [self.textLab heightWithWidth:width];
    self.textLab.frame =  CGRectMake(nameX, CGRectGetMaxY(self.iconView.frame) + kMargin, width, height);
    
    
    self.height = CGRectGetMaxY(self.textLab.frame) + kMargin;
    self.btn.frame = CGRectMake(0, 0, MYScreenW, self.height);
    
}


@end
