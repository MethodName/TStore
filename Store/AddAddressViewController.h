//
//  AddAddressViewController.h
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddAddressViewControllerDelegate <NSObject>

-(void)backReLoadData;

@end

@interface AddAddressViewController : UIViewController

@property(nonatomic,weak)id<AddAddressViewControllerDelegate>delegate;

@end
