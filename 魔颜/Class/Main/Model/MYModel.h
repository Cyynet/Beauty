//
//  MYModel.h
//  魔颜
//
//  Created by Meiyue on 15/10/26.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYLoginUser.h"
@interface MYModel : NSObject

@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic)  MYLoginUser *user;

@end
