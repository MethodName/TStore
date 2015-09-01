//
//  User.h
//  Store
//
//  Created by tangmingming on 15/8/26.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/**
 *  设置用户ID
 *
 *  @param userid 用户ID
 */
+(void)setShacreUserID:(NSInteger)userid;


/**
 *  获取共享的用户ID
 *
 *  @return 用户ID
 */
+(NSInteger)shareUserID;


/**
 *  设置物业编号
 *
 *  @param pmcID 物业编号
 */
+(void)setShacrePmcID:(NSInteger)pmcID;

/**
 *  获取物业编号
 *
 *  @return 物业编号
 */
+(NSInteger)sharePmcID;

@end
