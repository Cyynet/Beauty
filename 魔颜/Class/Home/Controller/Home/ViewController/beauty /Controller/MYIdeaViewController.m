//
//  MYIdeaViewController.m
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYIdeaViewController.h"

@interface MYIdeaViewController ()
@property (strong, nonatomic) NSArray *dataArr;

@end


@implementation MYIdeaViewController

- (NSArray *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [NSArray array];
        
    }
    return _dataArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor purpleColor];
//    self.collectionView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
//    
//#pragma mark -- 注册单元格
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bigCell];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
     cell.textLabel.text = [NSString stringWithFormat:@"pageView%ld",(long)indexPath.row];
    
    return cell;
}



@end
