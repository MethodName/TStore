//
//  ShopCarButton.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarButton : UIButton

#pragma mark -设置购物车按钮显示购物车中商品数量
-(void)setShopcarCountWithNum:(NSInteger) count;

@end
