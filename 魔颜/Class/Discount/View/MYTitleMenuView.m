//
//  HGTitleView.m
//  HiGo
//
//  Created by Think_lion on 15/7/25.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "MYTitleMenuView.h"

@interface MYTitleMenuView ()

/**
 *  滑块
 */
@property (nonatomic,weak) CALayer* sliderLayer;

/**
 *  当前所在的控制器的索引
 */
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation MYTitleMenuView

- (CALayer*)sliderLayer{
    if(!_sliderLayer) {
        
        CALayer* layer = [[CALayer alloc]init];
        [self.layer addSublayer:layer];
        _sliderLayer = layer;

        layer.cornerRadius = 4;
        layer.backgroundColor = UIColorFromRGB(0xb29e59).CGColor;
        layer.position = CGPointMake(0, self.bounds.size.height - 1);
        layer.zPosition = NSIntegerMax;
    }
    return _sliderLayer;
}

- (id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0; i < titleArr.count; i ++) {
            
            [self addButton:titleArr[i]];
         }
     }
    return self;
}

-(void)addButton:(NSString*)title
{
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = MianFont;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0xb29e59)
              forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)titleButtonClick:(UIButton*)btn
{
    self.currentIndex = btn.tag;
    [self sliderMoveToX:btn.center.x];
    [self didSelectedItem:btn.tag];
    if (self.titleBlock) {
        self.titleBlock(btn.tag);
    }
}

- (void)setShowSlider:(BOOL)ShowSlider
{
    _ShowSlider = ShowSlider;
    if (!_ShowSlider){
        self.sliderLayer.hidden = YES;
    }
    
}

- (void)setShowBorder:(BOOL)ShowBorder
{
    _ShowBorder = ShowBorder;
    if (_ShowBorder){
        
        for (UIButton *btn in self.subviews) {
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 0.3;
            
        }
    }
}


/**
 *  计算scrollView在屏幕中的偏移位置相对于sliderBar的宽度所对应的X
 */
- (void)sliderMoveToOffsetX:(CGFloat)x {
    
    [self layoutSubviews];
    
    //两个按钮中心点之间的间距
    CGFloat btnOffset = 0;
    UIButton* itemButton1 = [self.subviews firstObject];
    
    if(self.subviews.count > 1){
        UIButton* itemButton2 = [self.subviews objectAtIndex:1];
        btnOffset = itemButton2.center.x - itemButton1.center.x;
    }
    
    CGFloat offsetX = x / self.bounds.size.width * btnOffset;
    CGFloat basicX = itemButton1.center.x;
    CGFloat absX = basicX + offsetX;
    
    [self sliderMoveToX:absX];
    [self didSelectedItem:offsetX/btnOffset + 0.5];
    
}

/**
 *  slider在slider中移动到x的位置
 */
- (void)sliderMoveToX:(CGFloat)x {
    // 创建动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    // slider移动到 x
    pathAnimation.toValue = @(x);
    // 动画事件
    pathAnimation.duration = 0.3f;
    // 动画执行玩后 不删除动画
    pathAnimation.removedOnCompletion = NO;
    // 保持动画的最新状态
    pathAnimation.fillMode = kCAFillModeForwards;
    // 动画效果
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 执行动画
    [self.sliderLayer addAnimation:pathAnimation forKey:nil];
}

/**
 *  选中Item
 */
- (void)didSelectedItem:(NSInteger)itemIndex{
    
    self.currentIndex = itemIndex;
    for (int i = 0; i < self.subviews.count; i++) {
        if(i != itemIndex) {
            [self.subviews[i] setSelected:NO];
        }else{
            [self.subviews[i] setSelected:YES];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnY=0;
    int count=(int)self.subviews.count;
    CGFloat btnX = 0;
    CGFloat btnW = self.width/count;
    CGFloat btnH = self.height;
    for(int i = 0;i < count; i++){
        btnX = btnW * i;
        UIButton *btn=self.subviews[i];
        btn.tag = i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 设置layer的大小
    self.sliderLayer.bounds = CGRectMake(0, 0, btnW / 1.4, 2);
    
    // 更新slider的位置
    UIButton* currItem = [self.subviews objectAtIndex:self.currentIndex];
    [self sliderMoveToX:currItem.center.x];
    
}


@end
