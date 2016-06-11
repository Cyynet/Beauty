//
//  UIImageView+Extension.m
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)setHeaderWithURL:(NSString *)url
{
    [self setCircleHeaderWithURL:url];
}

- (void)setCircleHeaderWithURL:(NSString *)url
{
    UIImage *placeholder = [UIImage circleImageNamed:@"icon"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 下载失败, 不做任何处理, 让它显示占位图片
        if (image == nil) return;
        self.image = [image circleImage];
    }];
}

- (void)setRectHeaderWithURL:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon"]];
}


+ (instancetype )addImaViewWithFrame:(CGRect)frame
                            imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

+ (instancetype )addImaViewWithImageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}


@end
