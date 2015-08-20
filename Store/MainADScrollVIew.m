//
//  ADScrollVIew.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MainADScrollVIew.h"

@implementation MainADScrollVIew

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setContentSize:CGSizeMake(frame.size.width*4, frame.size.width*0.4)];
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;

    return self;
}

-(void)setImages:(NSArray *)imageArray{
    for (int i =0; i<4; i++) {
        UIImageView *image = [[UIImageView alloc] initWithImage: imageArray[i]];
        [image setFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.width*0.4)];
        [self addSubview:image];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_sreachBarDelegate searchBarEndEditing];
}


@end
