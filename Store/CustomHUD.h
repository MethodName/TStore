//
//  CustomHUD.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHUD : UIView

+(id)defaultCustomHUDWithFrame:(CGRect)frame;

@property(nonatomic,strong)UIImageView *animate;

@end
