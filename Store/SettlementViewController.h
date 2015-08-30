//
//  SettlementViewController.h
//  Store
//
//  Created by tangmingming on 15/8/21.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSreachBarDelegate.h"

@interface SettlementViewController : UIViewController

/**购物车商品列表*/
@property(nonatomic,strong)NSMutableArray *productList;
/**
 *  图片列表
 */
@property(nonatomic,strong)NSMutableDictionary *imageList;

/**
 *  类型【1：立即购买，2：购物车结算】
 */
@property(nonatomic,assign)NSInteger settlementType;


@property(nonatomic,weak)id<MainSreachBarDelegate>delegate;

@end
