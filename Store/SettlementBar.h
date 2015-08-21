//
//  SettlementBar.h
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementBar : UIView

@property(nonatomic,strong)UIButton *selectAllBtn;

@property(nonatomic,strong)UILabel *sumPrice;

@property(nonatomic,strong)UIButton *settlementBtn;

-(void)setSettlementBarWithSumPrice:(double)sumPrice productCount:(NSInteger)count;



@end
