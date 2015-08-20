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

-(void)setImages:(NSArray *)imageArray{
     [self setContentSize:CGSizeMake(self.frame.size.width*imageArray.count, self.frame.size.width*0.45)];
    for (int i =0; i<4; i++) {
        UIImageView *image = [[UIImageView alloc] initWithImage: imageArray[i]];
        [image setFrame:CGRectMake(self.frame.size.width*i, 5, self.frame.size.width, self.frame.size.width*0.45-10)];
        [self addSubview:image];
    }
    
}

@end
