//
//  MainMeunView.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MainMeunView.h"
#import "MainMenuItem.h"
#import "StoreDefine.h"
#import "ProductTypes.h"
#import "ToolsOriginImage.h"


@implementation MainMeunView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    MainMenuItem *hotBtn = [MainMenuItem buttonWithType:UIButtonTypeCustom];
    [hotBtn setFrame:CGRectMake(0, 10, 80, 80)];
     UIImage *img =[UIImage imageWithCGImage:[[UIImage imageNamed:@"tuijian"] CGImage] scale:1.8 orientation:UIImageOrientationUp];
    [hotBtn setImage:img forState:0];
    [hotBtn setTitle:@"热门推荐" forState:0];
    [hotBtn setTitleColor:[UIColor grayColor] forState:0];
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    hotBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    hotBtn.tag = PRODUCT_LIST_HOT_TYPE;//热门推荐
    [hotBtn setCenter:CGPointMake(width/8, height/2)];
    [hotBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hotBtn];
    
    return self;
}

#pragma mark -设置类型
-(void)setMenuItems:(NSArray *)menuItems{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    for (int i =0; i<3; i++)
    {
        ProductTypes *type = menuItems[i];
        MainMenuItem *hotBtn = [MainMenuItem buttonWithType:UIButtonTypeCustom];
        int index = (i+1)%4;
        [hotBtn setFrame:CGRectMake(index*width/4, 10, 80, 80)];
        UIImage *img =[UIImage imageWithCGImage:[[UIImage imageNamed:type.PTIconUrl] CGImage] scale:1.8 orientation:UIImageOrientationUp];
        [hotBtn setImage: [ToolsOriginImage OriginImage:img scaleToSize:CGSizeMake(50, 50)] forState:0];
        [hotBtn setTitle:type.PTName forState:0];
        [hotBtn setTitleColor:[UIColor grayColor] forState:0];
        [hotBtn setTag:type.PTID];
        hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        hotBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        
        [hotBtn setCenter:CGPointMake(width/4*index + width/8, height/2)];
        [hotBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hotBtn];

    }
}

#pragma mark -类别按钮点击事件
-(void)typeBtnClick:(UIButton *)typeBtn{
    [_delegate productListWithType:typeBtn.tag];
}



@end
