//
//  ProductListMenuView.h
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListMenuView : UIView


@property(nonatomic,strong)UIButton *screening;

@property(nonatomic,strong)UIButton *sort;

@property(nonatomic,strong)UIButton *collection;

+(ProductListMenuView *)defaultViewWithFrame:(CGRect)frame;



@end
