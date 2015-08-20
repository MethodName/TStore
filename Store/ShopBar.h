//
//  ShopBar.h
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopBarDelegate.h"


@interface ShopBar : UIView

@property(nonatomic,weak)id<ShopBarDelegate>delegate;

@property(nonatomic,strong)UIButton *shopCar;

@property(nonatomic,strong)UILabel *shopCatCount;

@property(nonatomic,strong)UIButton *addShopCar;

@property(nonatomic,strong)UIButton *bayShop;

-(void)setShopCatCountNum:(NSInteger)num;



@end
