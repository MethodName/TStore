//
//  CustomHUD.m
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "CustomHUD.h"

@implementation CustomHUD

+(id)defaultCustomHUDWithFrame:(CGRect)frame
{
    CustomHUD *hud = [[CustomHUD alloc]initWithFrame:frame];
    [hud setBackgroundColor:[UIColor whiteColor]];
    hud.animate = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width*0.4, frame.size.width*0.38)];
    [hud.animate setCenter:hud.center];
    NSMutableArray *images = [NSMutableArray new];
    for (int i =0; i<28; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]]];
    }
    [hud.animate setAnimationImages:images];
    [hud.animate setAnimationDuration:1.5];
    [hud.animate setAnimationRepeatCount:100000000];
    [hud addSubview:hud.animate];
    return hud;
}

@end
