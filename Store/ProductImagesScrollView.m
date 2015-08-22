//
//  ProductImagesScrollView.m
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductImagesScrollView.h"

@implementation ProductImagesScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
   
    self.backgroundColor = [UIColor colorWithRed:(230.0/255.0) green:(230.0/255.0) blue:(230.0/255.0) alpha:1.0];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    
    return self;
}

-(void)setImages:(NSArray *)imageArray
{
     [self setContentSize:CGSizeMake(self.frame.size.width*imageArray.count, self.frame.size.width*0.8)];
    for (int i =0; i<4; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.width-10)];
        //异步加载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *photourl = [NSURL URLWithString:@"http://www.baoshanjie.com/data/attachment/forum/201505/02/133100uvpkv4gaeynpvjnh.jpg"];
            //url请求实在UI主线程中进行的
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];//通过网络url获取uiimage

            //UIImage *img =[UIImage imageNamed:imageArray[i]];
            //sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                  [image setImage:img];
                
            });
        });
       [self addSubview:image];
       
    }
    
}

@end
