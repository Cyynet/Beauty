//
//  MYCollectionViewCell.m
//  魔颜
//
//  Created by Meiyue on 16/1/11.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYCollectionViewCell.h"

@interface MYCollectionViewCell ()


@end

@implementation MYCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        self.imagView = iconView;
        [self.contentView addSubview:iconView];
        
    }
    return self;
}

- (void)setSalonMode:(MYSalonModel *)salonMode
{
    _salonMode = salonMode;

    [self.imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,salonMode.TYPE_PIC]]];
   
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.imagView.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height);
      
}

@end
