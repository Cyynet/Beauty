//
//  MYTranformationHeaderview.m
//  魔颜
//
//  Created by abc on 15/10/12.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYTranformationHeaderview.h"

#import "MYCategoryBtn.h"


@interface MYTranformationHeaderview ()

@property(strong,nonatomic)MYCategoryBtn *btn;

@end


@implementation MYTranformationHeaderview


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self addBtnWithTitle:@"祛皱" imageName:@"quzhou" seaction:@selector(clickquzhouBtn) tag:12];
        [self addBtnWithTitle:@"脸型" imageName:@"face" seaction:(@selector(clickfaceBtn)) tag:11];
        [self addBtnWithTitle:@"眼睛" imageName:@"eyes" seaction:@selector(clickeyesBtn) tag:8];
        [self addBtnWithTitle:@"鼻部" imageName:@"nose" seaction:@selector(clicknoseBtn) tag:10];
        [self addBtnWithTitle:@"唇嘴" imageName:@"mouse" seaction:@selector(clickmouseBtn) tag:4];
        [self addBtnWithTitle:@"胸" imageName:@"bresh" seaction:@selector(clickxiongBtn) tag:33];
        [self addBtnWithTitle:@"身体塑形" imageName:@"body" seaction:@selector(clickbodyBtn) tag:37];
    }
    return self;
    
}

//记得改label字体
-(void)addBtnWithTitle:(NSString *)title imageName:(NSString *)imageName seaction:(SEL)seaction tag:(int)tag
{
    MYCategoryBtn *btn = [MYCategoryBtn addbtn];
    
    btn.titleLabel.text = title;
    btn.titleLabel.font = leftFont;
    [btn setTintColor:titlecolor];
    btn.imageView.image = [UIImage imageNamed:imageName];
    [btn.clickBtn addTarget:self action:seaction forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
}


-(void)clickquzhouBtn
{
    if ([self.quzhouq respondsToSelector:@selector(quzhou)])
    {
        [self.quzhouq quzhou];
    }    
}


-(void)clickfaceBtn
{
    if ([self.lianxing respondsToSelector:@selector(lianxing)])
    {
        [self.lianxing lianxing];
    }
}
-(void)clickeyesBtn
{
    if ([self.yanmie respondsToSelector:@selector(yanmei)])
    {
        [self.yanmie yanmei];
    }
    
}
-(void)clicknoseBtn
{
    
    if ([self.bibu respondsToSelector:@selector(bibu)])
    {
        [self.bibu bibu];
    }
}
-(void)clickmouseBtn
{
    if ([self.kouchun respondsToSelector:@selector(kouchun)])
    {
        [self.kouchun kouchun];
    }
    
}
-(void)clickxiongBtn
{
    if ([self.xiong respondsToSelector:@selector(xiong)])
    {
        [self.xiong xiong];
    }
    
}
-(void)clickbodyBtn
{
    
    if ([self.shentishuxing respondsToSelector:@selector(shentishuxing)])
    {
        [self.shentishuxing shentishuxing];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (MYScreenW >= 414) {
        
        for (int i = 0; i < self.subviews.count ; i++) {
            MYCategoryBtn *btn = (MYCategoryBtn *)self.subviews[i];
            btn.frame = CGRectMake(i * self.width * 0.10 + 7  , 0,  MYScreenW    , self.height );
            
        }
    }
    else if(MYScreenW >= 375)
    {
        
        for (int i = 0; i < self.subviews.count ; i++) {
            MYCategoryBtn *btn = (MYCategoryBtn *)self.subviews[i];
            btn.frame = CGRectMake(i * self.width * 0.1 +5   , 0,  MYScreenW    , self.height );
            
        }
    }
    
    else if (MYScreenW >= 320)
    {
        for (int i = 0; i < self.subviews.count ; i++) {
            MYCategoryBtn *btn = (MYCategoryBtn *)self.subviews[i];
            btn.frame = CGRectMake(i * self.width * 0.125  , 0,  MYScreenW  , self.height );
            
        }
    }
}
@end
