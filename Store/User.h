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


+(void)setShacrePmcID:(NSInteger)pmcID;


+(NSInteger)sharePmcID;

@end
