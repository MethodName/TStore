//
//  MainMeunView.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MainMeunView.h"
#import "MainMenuItem.h"


@implementation MainMeunView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
   
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    MainMenuItem *hotBtn = [MainMenuItem buttonWithType:UIButtonTypeCustom];
    [hotBtn setFrame:CGRectMake(0, 10, 80, 80)];
    [hotBtn setImage:[UIImage imageNamed:@"tuijian_44.png"] forState:0];
    [hotBtn setTitle:@"热门推荐" forState:0];
    [hotBtn setTitleColor:[UIColor grayColor] forState:0];
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    hotBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
  
    [hotBtn setCenter:CGPointMake(width/8, height/2)];
    
    [self addSubview:hotBtn];
    
    return self;
}


-(void)setMenuItems:(NSArray *)menuItems{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    for (int i =0; i<3; i++) {
        MainMenuItem *hotBtn = [MainMenuItem buttonWithType:UIButtonTypeCustom];
        int index = (i+1)%4;
        [hotBtn setFrame:CGRectMake(index*width/4, 10, 80, 80)];
        [hotBtn setImage:[UIImage imageNamed:@"tuijian_44.png"] forState:0];
        [hotBtn setTitle:@"热门推荐" forState:0];
        [hotBtn setTitleColor:[UIColor grayColor] forState:0];
        hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        hotBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        
        [hotBtn setCenter:CGPointMake(width/4*index + width/8, height/2)];
        
        [self addSubview:hotBtn];

    }
}



@end
