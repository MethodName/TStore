//
//  CustomBar.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "CustomBar.h"

@implementation CustomBar

+(id)customBarWithImage:(UIImage*)image{
    CustomBar *bar = [[CustomBar alloc]init];
    [bar setImage:image];

    return bar;
}

@end
