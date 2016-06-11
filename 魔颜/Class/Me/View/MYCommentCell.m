//
//  MYCommentCell.m
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYCommentCell.h"
#import "MYCircleComment.h"
#import "NSString+File.h"

#define  textcolor  MYColor(80, 80, 80)

@interface MYCommentCell ()

/*
 @brief 回复
 */
@property(weak, nonatomic) UILabel *nameLabel;
/** 时间标签 */
@property (weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic)  UILabel *textLab;

@end

@implementation MYCommentCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"Cell%ld",(long)[indexPath row]];
    MYCommentCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYCommentCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //名字描述
        UILabel *nameLabel = [UILabel addLabelWithTitle:nil titleColor:titlecolor font:leftFont];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:self.nameLabel];
        
        //标题
        UILabel *textLab = [[UILabel alloc] init];
        textLab.font = leftFont;
        textLab.numberOfLines = 0;
        textLab.textColor = titlecolor;
        self.textLab = textLab;
        [self.contentView addSubview:textLab];
        
        UILabel *timeLabel = [UILabel addLabelWithTitle:@"" titleColor:subTitleColor font:leftFont];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setHostName:(NSString *)hostName
{
    _hostName = hostName;
}

- (void)setReply:(MYCircleReply *)reply
{
    _reply = reply;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 回复了 %@",reply.userName,_hostName];
    
    self.timeLabel.text = reply.createTime;
    self.textLab.text = reply.content;
    [self.textLab setRowSpace:6];
    
    [self layoutSubviews];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat nameW = [self.nameLabel.text widthWithFont:leftFont];
    self.nameLabel.frame = CGRectMake(50, kMargin,nameW, 20);
    
    CGFloat timeW = [self.timeLabel.text widthWithFont:leftFont];
    self.timeLabel.frame = CGRectMake(MYScreenW - timeW - kMargin, kMargin, timeW, 20);
    
    
    CGFloat width = MYScreenW - 60;
    CGFloat height = [self.textLab heightWithWidth:width];
    self.textLab.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 5, width, height);
    
    self.height = CGRectGetMaxY(self.textLab.frame) + kMargin;
 
    
}


@end
