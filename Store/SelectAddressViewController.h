//
//  SelectAddressViewController.h
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectAddressViewControllerDelegate <NSObject>

-(void)addressWithStr:(NSString *)str;

@end


@interface SelectAddressViewController : UIViewController

@property(nonatomic,weak)id<SelectAddressViewControllerDelegate>delegate;

@end
