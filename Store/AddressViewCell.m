//
//  AddressViewCell.m
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "AddressViewCell.h"
#import "CustomAnimate.h"


@implementation AddressViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        /**
         *  收货人
         */
         CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height =width*0.4;
        _consignee = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, width*0.5, 20)];
        [_consignee setFont:[UIFont fontWithName:@"Verdana-Bold" size:15.0]];
       // [_consignee setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:_consignee];
        
        /**
         联系方式
         */
        _telephone = [[UILabel alloc]initWithFrame:CGRectMake(width*0.5, 15, width*0.5-15, 20)];
        [_telephone setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_telephone];
        
        
        /**
         *  详细地址
         */
        _addressDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, width-30, 40)];
        [_addressDetail setNumberOfLines:0];
        [_addressDetail setTextColor:[UIColor lightGrayColor]];
        [_addressDetail setFont:[UIFont fontWithName:@"Verdana-Bold" size:13.0]];
        [self.contentView addSubview:_addressDetail];
        
        /**
         *  设置默认地址按钮
         */
        _defaultAddress = [[UIButton alloc]initWithFrame:CGRectMake(15, height-35, 110, 25)];
        //_defaultAddress setContentMode:(UIViewContentMode)
        [_defaultAddress setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 85)];
        [_defaultAddress.titleLabel setTextColor:[UIColor lightGrayColor]];
        [_defaultAddress.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:13.0]];
        [self.contentView addSubview:_defaultAddress];
        
        
        _defaultAddressDesc = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 80, 25)];
        [_defaultAddressDesc setTextColor:[UIColor lightGrayColor]];
        [_defaultAddressDesc setFont:[UIFont fontWithName:@"Verdana-Bold" size:13.0]];
        [_defaultAddress addSubview:_defaultAddressDesc];
        
        [_defaultAddress addTarget:self action:@selector(defaultAddressClick) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  编辑
         */
        
        _editBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setFrame:CGRectMake(width-150, height-35, 65, 28)];
        [_editBtn setImage:[UIImage imageNamed:@"address_edit"] forState:0];
        [self.contentView addSubview:_editBtn];
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  删除
         */
        _deleteBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setFrame:CGRectMake(width-80, height-35, 65, 28)];
        [_deleteBtn setImage:[UIImage imageNamed:@"address_delete"] forState:0];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    return  self;
}

#pragma mark -设置值
-(void)setAddressValueWithAddress:(StoreAddressModel *)address
{
    [_consignee setText:address.consignee];
    [_telephone setText:address.telephone];
    [_addressDetail setText:[NSString stringWithFormat:@"%@%@",address.provinceCityDistrict,address.addressDetail]];
    
    [_deleteBtn setTag:address.addressID];
    _addressID = address.addressID;
    
    //是否是默认地址
    if (address.isDefault)
    {
        [_defaultAddress setImage:[UIImage imageNamed:@"pay_select"] forState:0];
        //如果是默认的，设置tag为0【反转】
        _defaultState = 0;
        [_defaultAddressDesc setText:@"默认地址"];
    }
    else
    {
        [_defaultAddress setImage:[UIImage imageNamed:@"pay_select_press"] forState:0];
        //如果不是默认的，设置tag为1【反转】
        _defaultState = 1;
        [_defaultAddressDesc setText:@"设为默认"];
    }
   
}


#pragma mark -设为默认地址
-(void)defaultAddressClick
{
     [CustomAnimate scaleAnime:_defaultAddress FromValue:1.0 ToValue:1.5 Duration:0.25 Autoreverse:YES RepeatCount:1];
    [_delegate setDefaultAddressWithBtn:_defaultAddress AddressID:_addressID State:_defaultState];
}

#pragma mark -编辑
-(void)editBtnClick
{
    
    [_delegate editAddressWithAddress:_addressDetail.text Consignee:_consignee.text Telephone:_telephone.text AddressID:_addressID];
}

#pragma mark -删除
-(void)deleteBtnClick:(UIButton *)del
{
     [CustomAnimate scaleAnime:del FromValue:1.0 ToValue:1.5 Duration:0.25 Autoreverse:YES RepeatCount:1];
     [_delegate deleteAddressWithAddressID:del.tag];
}

/**
 *  画线
 *
 *  @param rect
 */
-(void)drawRect:(CGRect)rect
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //1、获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint ps1[] = {CGPointMake(15,width*0.4-40 ), CGPointMake(width-15, width*0.4-40)};
    CGContextAddLines(context, ps1, sizeof(ps1)/sizeof(CGPoint));
    CGContextSetLineWidth(context, 0.8);
    [[UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0]set];
    CGContextDrawPath(context, kCGPathStroke);
}






@end
