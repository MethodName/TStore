//
//  User.m
//  Store
//
//  Created by tangmingming on 15/8/26.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "User.h"

static NSInteger userID;
@implementation User

+(void)setShacreUserID:(NSInteger)userid{
    userID = userid;
}

+(NSInteger)shareUserID{
    return userID;
}

@end
