//
//  MYTranformationHeaderview.h
//  魔颜
//
//  Created by abc on 15/10/12.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol quzhoudelegate <NSObject>
-(void)quzhou;
@end

@protocol lianxingdelegate <NSObject>
-(void)lianxing;
@end
@protocol yanmeidelegate <NSObject>
-(void)yanmei;
@end
@protocol bibudelegate <NSObject>
-(void)bibu;
@end
@protocol kouchundelegate <NSObject>
-(void)kouchun;
@end
@protocol xiongdelegate <NSObject>
-(void)xiong;
@end
@protocol shentishuxingdelegate <NSObject>
-(void)shentishuxing;
@end





@interface MYTranformationHeaderview : UIView


@property(weak,nonatomic) id<quzhoudelegate> quzhouq;

@property(weak,nonatomic) id<lianxingdelegate> lianxing;
@property(weak,nonatomic) id<yanmeidelegate> yanmie;
@property(weak,nonatomic) id<bibudelegate> bibu;
@property(weak,nonatomic) id<kouchundelegate> kouchun;
@property(weak,nonatomic) id<xiongdelegate> xiong;
@property(weak,nonatomic) id<shentishuxingdelegate> shentishuxing;


@end
