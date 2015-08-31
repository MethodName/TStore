//
//  User.m
//  Store
//
//  Created by tangmingming on 15/8/26.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "User.h"
/**
 *  用户编号
 */
static NSInteger userID;

/**
 *  物业编号
 */
static NSInteger pmcID;


@implementation User

+(void)setShacreUserID:(NSInteger)userid
{
    userID = userid;
}

+(NSInteger)shareUserID{
    return userID;
}


+(void)setShacrePmcID:(NSInteger)pmcid
{
    pmcID = pmcid;
}

+(NSInteger)sharePmcID
{
    return pmcID;
}

@end
