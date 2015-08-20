//
//  TopProductsView.h
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopProductsViewDelegate <NSObject>

-(void)productDetailWithProductID:(NSString *)proid;

@end

@interface TopProductsView : UIView

@property(nonatomic,weak)id<TopProductsViewDelegate>delegate;

//@property(nonatomic,strong)
-(void)setProducts:(NSArray *)products;


@end
