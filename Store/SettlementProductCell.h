//
//  SettlementProductCell.h
//  Store
//
//  Created by tangmingming on 15/8/21.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementProductCell : UITableViewCell

@property(nonatomic,strong)UIImageView *productImage;

@property(nonatomic,strong)UILabel *name;

@property(nonatomic,strong)UILabel *productName;

@property(nonatomic,strong)UILabel *detail;

@property(nonatomic,strong)UILabel *price;

@property(nonatomic,strong)UILabel *sumPrice;

@property(nonatomic,strong)UILabel * productCount;

@end
