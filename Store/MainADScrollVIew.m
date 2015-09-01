//
//  ADScrollVIew.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MainADScrollVIew.h"
#import "StoreDefine.h"


@interface MainADScrollVIew()

@property(nonatomic,strong)NSTimer *timerMove;

@property(nonatomic,assign)NSInteger index;

@end

@implementation MainADScrollVIew

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
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
   // NSLog(@"%@",imageArray);
    
    [self setContentSize:CGSizeMake(self.frame.size.width*imageArray.count, self.frame.size.width*0.6)];
    for (int i =0; i<imageArray.count; i++)
    {
        //创建ImageView
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.width*0.6)];
        //确定路径
        NSURL *photourl = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@",SERVER_IMAGES_ROOT_PATH,imageArray[i]]];
        //异步网络加载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];//通过网络url获取uiimage
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI
                [image setImage:img];
            });
            
        });
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
    if (_index==self.contentSize.width/self.frame.size.width)
    {
        _index = 0;
    }
    
}

#pragma mark -tap广告收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_sreachBarDelegate searchBarEndEditing];
}


@end
