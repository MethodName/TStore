//
//  SettlementConfirmView.h
//  Store
//
//  Created by tangmingming on 15/8/21.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementConfirmView : UIView
/**
 *  总金额
 */
@property(nonatomic,strong)UILabel *sumPrice;

/**
 *  运费
 */
@property(nonatomic,strong)UILabel *freight;


/**
 *  确认按钮
 */
@property(nonatomic,strong)UIButton *settlementBtn;

@end
