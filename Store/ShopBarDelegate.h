//
//  ShopBarDelegate.h
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShopBarDelegate <NSObject>


@optional

-(void)pushToShopCarView;

-(void)addShopCar;

-(void)buyProduct;


@end
