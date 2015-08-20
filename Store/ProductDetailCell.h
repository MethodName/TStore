//
//  ProductDetailCell.h
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconTitleButton.h"



@interface ProductDetailCell : UITableViewCell


@property(nonatomic,strong)UILabel *name;

@property(nonatomic,strong)IconTitleButton *collectBtn;

@property(nonatomic,strong)UIButton *collectBtn1;

@property(nonatomic,strong)UILabel *productName;

@property(nonatomic,strong)UILabel *productPrice;

@property(nonatomic,strong)UILabel *yunfen;

@property(nonatomic,strong)UIButton *haoPing;

@property(nonatomic,strong)UIButton *zhongPing;

@property(nonatomic,strong)UIButton *chaPing;






@end
