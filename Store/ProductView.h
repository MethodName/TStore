//
//  ProductView.h
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductView : UIButton

@property(nonatomic,strong)NSString *ProductID;

@property(nonatomic,strong)UIImageView *productImage;

@property(nonatomic,strong)UILabel *productName;

@property(nonatomic,strong)UILabel *productDesc;

@end
