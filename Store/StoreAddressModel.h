//
//  StoreAddressModel.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreAddressModel : NSObject

@property(nonatomic,assign)NSInteger AddressID;

@property(nonatomic,strong)NSString *ProvinceCityDistrict;

@property(nonatomic,strong)NSString *AddressDetail;

@property(nonatomic,strong)NSString *Consignee;

@property(nonatomic,strong)NSString *Telephone;

@property(nonatomic,assign)BOOL IsDefault;

@property(nonatomic,assign)NSInteger UserID;

@end
