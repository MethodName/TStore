//
//  ProductImagesScrollView.m
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductImagesScrollView.h"
#import "StoreDefine.h"

@implementation ProductImagesScrollView

#pragma mark -初始化方法
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    self.backgroundColor = [UIColor colorWithRed:(230.0/255.0) green:(230.0/255.0) blue:(230.0/255.0) alpha:1.0];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    
    return self;
}


#pragma mark -设置商品图片
-(void)setImages:(NSArray *)imageArray
{
     [self setContentSize:CGSizeMake(self.frame.size.width*imageArray.count, self.frame.size.width*0.8)];
    for (int i =0; i<imageArray.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.width-10)];
        [image setImage:[UIImage imageNamed:@"placeholderImage"]];
        //异步加载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            NSString *path =[NSString stringWithFormat:@"%s%@",SERVER_IMAGES_ROOT_PATH,imageArray[i]];
            //获取图片路径
            NSURL *photourl = [NSURL URLWithString:path];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
            /**
             *  在主线程中更新UI
             */
            dispatch_async(dispatch_get_main_queue(), ^
            {
                  [image setImage:img];
            });
        });
       [self addSubview:image];
       
    }
    
}

@end
