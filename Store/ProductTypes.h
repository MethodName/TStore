//
//  ProductTypes.h
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductTypes : NSObject
/**
 *  物业编号
 */
@property(nonatomic,assign)NSInteger pmcID;
/**
 *  类型编号
 */
@property(nonatomic,assign)NSInteger ptID;
/**
 *  类型名称
 */
@property(nonatomic,strong)NSString *ptName;
/**
 *  icon路径
 */
@property(nonatomic,strong)NSString *ptIconUrl;
/**
 *  父级编号
 */
@property(nonatomic,assign)NSInteger ptParentID;

@end;
