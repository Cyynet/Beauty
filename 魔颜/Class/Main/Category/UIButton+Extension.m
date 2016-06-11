//
//  UIButton+Extension.m
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "UIButton+Extension.h"

/**
 *  内部类声明、实现
 */
@interface LLExtensionButton : UIButton

@property(nonatomic,copy) ButtonActionBlock actionSel;

@end

@implementation LLExtensionButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)buttonClick:(UIButton *)button
{
    if (self.actionSel)
    {
        self.actionSel(self);
    }
}

@end


@implementation UIButton (Extension)

+ (instancetype)addButtonWithFrame:(CGRect)frame
                   backgroundColor:(UIColor *)backgroundColor
                            Target:(id)target action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    return btn;

}


/*
 @brief 文字按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                   backgroundColor:(UIColor *)backgroundColor
                        titleColor:(UIColor *)titleColor
                              font:(UIFont *)font
                            Target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    
//    btn.layer.borderWidth = 0.6;
//    btn.layer.cornerRadius = 3;
    //    btn.layer.borderColor = MYColor(193, 177, 122).CGColor;
    
    return btn;
    
}



/*
 @brief 图片按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame
                             image:(NSString *)image
                         highImage:(NSString *)highImage
                   backgroundColor:(UIColor *)backgroundColor
                            Target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    // 设置图片
    
    if (image) {
        
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (highImage) {
        
        [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    return btn;
    
}

+ (instancetype)addButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                        titleColor:(UIColor *)titleColor
                              font:(UIFont *)font
                             image:(NSString *)image
                         highImage:(NSString *)highImage
                   backgroundColor:(UIColor *)backgroundColor
                            Target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    
    //设置文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
     btn.titleLabel.font = font;
    
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    return btn;
    
    
}



@end
