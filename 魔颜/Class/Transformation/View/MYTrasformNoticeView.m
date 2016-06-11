//
//  WQTrasformNoticeView.m
//  魔颜
//
//  Created by 周文静 on 15/9/26.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYTrasformNoticeView.h"
@interface MYTrasformNoticeView ()

@property(strong,nonatomic) UIButton *btn;

@end


@implementation MYTrasformNoticeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor redColor];
        self.btn = btn;
    
        [self addSubview:btn];
        
        
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super subviews];
    self.btn.frame = CGRectMake(0, 120, MYScreenW, 40);

}

@end
