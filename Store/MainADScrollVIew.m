//
//  ADScrollVIew.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MainADScrollVIew.h"


@interface MainADScrollVIew()

@property(nonatomic,strong)NSTimer *timerMove;

@property(nonatomic,assign)NSInteger index;

@end

@implementation MainADScrollVIew

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setContentSize:CGSizeMake(frame.size.width*4, frame.size.width*0.4)];
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;

    return self;
}

#pragma mark -设置广告图片
-(void)setImages:(NSArray *)imageArray
{
    for (int i =0; i<4; i++) {
        UIImageView *image = [[UIImageView alloc] initWithImage: imageArray[i]];
        [image setFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.width*0.4)];
        [self addSubview:image];
    }
     _index = 0;
    _timerMove =[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(moveImage) userInfo:nil repeats:YES];
    [_timerMove fire];
   
}

//延时器移动图片
-(void)moveImage
{
    //NSLog(@"%d",_index);
    [UIView animateWithDuration:0.5 animations:^{
         [self setContentOffset:CGPointMake(_index*self.frame.size.width, 0)];
    }];
     [_imageMoveDelegate imageMoveWithIndex:_index];
    _index ++;
    if (_index==4) {
        _index = 0;
    }
    
}

#pragma mark -tap广告收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_sreachBarDelegate searchBarEndEditing];
}


@end
