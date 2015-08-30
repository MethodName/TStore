//
//  StoreAddressModel.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreAddressModel : NSObject
/**
 *  地址编号
 */
@property(nonatomic,assign)NSInteger addressID;
/**
 *  城市
 */
@property(nonatomic,strong)NSString *provinceCityDistrict;
/**
 *  详细地址
 */
@property(nonatomic,strong)NSString *addressDetail;
/**
 *  收货人
 */
@property(nonatomic,strong)NSString *consignee;
/**
 *  联系电话
 */
@property(nonatomic,strong)NSString *telephone;
/**
 *  是否是默认地址
 */
@property(nonatomic,assign)BOOL isDefault;
/**
 *  所属用户编号
 */
@property(nonatomic,assign)NSInteger userID;

@end
