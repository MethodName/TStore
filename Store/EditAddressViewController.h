//
//  EditAddressViewController.h
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditAddressViewControllerDelegate <NSObject>

-(void)backReLoadData;

@end


@interface EditAddressViewController : UIViewController

@property(nonatomic,weak)id<EditAddressViewControllerDelegate>delegate;

@property(nonatomic,strong)NSString *oldAddress;

@property(nonatomic,strong)NSString *oldConsignee;

@property(nonatomic,strong)NSString *oldTelephone;


@end
