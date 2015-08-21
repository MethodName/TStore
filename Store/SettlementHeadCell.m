//
//  SettlementCell.m
//  Store
//
//  Created by tangmingming on 15/8/21.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "SettlementHeadCell.h"

@implementation SettlementHeadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:@"settlementCell"])
    {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 15, 20)];
        [self.contentView addSubview:_icon];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 200, 20)];
        [_name setTextColor:[UIColor lightGrayColor]];
        [_name setFont:[UIFont fontWithName:@"Thonburi-Bold" size:14.0]];
        [self.contentView addSubview:_name];
    }
    
    return self;
}

@end
