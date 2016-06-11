//
//  MYCollectionHeadView.h
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MYBeautyBlock)(NSArray *tagArr,UIButton *btn);

@interface MYCollectionHeadView : UICollectionReusableView
typedef void(^MyBtnBlock)(NSInteger btnIndex);
@property (retain, nonatomic) NSArray * showItems;

/** <#注释#> */
@property (strong, nonatomic) NSArray *salonExpand;
@property (copy, nonatomic)   MyBtnBlock btnIndex;

@property (copy, nonatomic) MYBeautyBlock beautyBlock;

@end
