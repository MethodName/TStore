//
//  PlayTypeCell.m
//  Store
//
//  Created by tangmingming on 15/8/31.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "PlayTypeCell.h"

@implementation PlayTypeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-44, 8, 44, 44)];
        [_selectBtn setHidden:YES];
        
        [self.contentView addSubview:_selectBtn];
    }
    return self;
}

@end
