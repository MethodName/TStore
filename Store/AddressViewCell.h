//
//  AddressViewCell.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreAddressModel.h"

@interface AddressViewCell : UITableViewCell

/**收货人*/
@property(nonatomic,strong)UILabel *consignee;

/**联系方式*/
@property(nonatomic,strong)UILabel *telephone;

/**详细地址*/
@property(nonatomic,strong)UILabel *addressDetail;

/**设置默认地址按钮*/
@property(nonatomic,strong)UIButton * defaultAddress;

@property(nonatomic,strong)UILabel  * defaultAddressDesc;

/**编辑按钮*/
@property(nonatomic,strong)UIButton *editBtn;

/**删除按钮*/
@property(nonatomic,strong)UIButton *deleteBtn;



-(void)setAddressValueWithAddress:(StoreAddressModel *)address;

@end
