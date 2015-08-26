//
//  ProductListTableViewController.h
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSreachBarDelegate.h"


@interface ProductListTableViewController : UIViewController

@property(nonatomic,weak)id<MainSreachBarDelegate>delegate;

/**
 *  当前页
 */
@property(nonatomic,assign)int pageIndex;
/**
 *  页大小
 */
@property(nonatomic,assign)int pageSize;
/**
 *  商品名称
 */
@property(nonatomic,strong)NSString *productName;
/**
 *  物业编号
 */
@property(nonatomic,assign)NSInteger pmcID;
/**
 *  商品类型
 */
@property(nonatomic,assign)NSInteger ptID;
/**
 *  排序字段
 */
@property(nonatomic,strong)NSString *order;
/**
 *  倒序，升序[0：升序   1：降序]
 */
@property(nonatomic,assign)NSInteger descend;




@end
