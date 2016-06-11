//
//  MYDiaryCell.m
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYDiaryCell.h"
#import "NSString+Extension.h"

@interface MYDiaryCell ()
/**大图片*/
@property (weak, nonatomic) UIImageView *imagView;

/**  */
@property (weak, nonatomic) UIView *bgView;
@property(strong,nonatomic) UILabel * coverview;
@property(strong,nonatomic) UILabel * desclable;
@property(strong,nonatomic) UIView * line;
@property(strong,nonatomic) UIView * converbackview;


@end

@implementation MYDiaryCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"Cell%ld",(long)[indexPath row]];
    MYDiaryCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYDiaryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        self.imagView = iconView;
        [self.contentView addSubview:iconView];
        
        
        UIView *converbackview = [[UIView alloc]init];
        [iconView addSubview:converbackview];
        converbackview.backgroundColor = [UIColor whiteColor];
        converbackview.alpha = 0.7;
        self.converbackview = converbackview;
        
        
        UILabel *coverview = [[UILabel alloc]init];
        [iconView addSubview:coverview];
        self.coverview = coverview;
        coverview.backgroundColor = [UIColor clearColor];
        coverview.font = MYSFont(14);
        coverview.textColor = UIColorFromRGB(0x1a1a1a);
        
        
        UILabel *desclable = [[UILabel alloc]init];
        [self addSubview:desclable];
        self.desclable = desclable;
        desclable.font = MYFont(13);
        desclable.textColor = titlecolor;
        desclable.numberOfLines = 2;
       
        
        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = UIColorFromRGB(0xcccccc);
        self.line = line;
        line.alpha = 0.5;
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imagView.frame = CGRectMake(5, 5, MYScreenW - 10, 217);
    self.converbackview.frame = CGRectMake(0, self.imagView.height-40, self.imagView.width, 40);
    self.coverview.frame  = CGRectMake(0, self.imagView.height-40, self.imagView.width, 40);
    
    CGFloat desclableheiht = [self.desclable.text heightWithFont:MYFont(13) withinWidth:MYScreenW-20];
    CGFloat height;

    if (desclableheiht >15) {
        height = 40;
          self.desclable.frame = CGRectMake(kMargin, self.imagView.bottom+5, MYScreenW - MYMargin, height);
    }else{
        
        height = 30;
        self.desclable.frame = CGRectMake(kMargin, self.imagView.bottom+5, MYScreenW - MYMargin, height);
    }
  
    self.line.frame = CGRectMake(0, self.desclable.bottom+3+5, MYScreenW, 0.5);
    
}

-(void)setDiarymode:(MYDiary *)diarymode
{
    _diarymode = diarymode;
    self.coverview.text = [NSString stringWithFormat:@"  %@",diarymode.title];
    self.desclable.text = diarymode.content;
    [self.desclable setRowSpace:5.0];
    //[self.desclable setColumnSpace:1.0];
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,diarymode.homePagePic]]];

    [self layoutSubviews];
}



@end
