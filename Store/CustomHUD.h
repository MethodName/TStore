//
//  CustomHUD.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHUD : UIView

@property(nonatomic,strong)UIImageView *animate;


+(id)defaultCustomHUDWithFrame:(CGRect)frame;

+(id)defaultCustomHUDSimpleWithFrame:(CGRect)frame;

-(void)startLoad;

-(void)loadHide;

-(void)startSimpleLoad;

-(void)simpleComplete;


@end
