//
//  ShopCarViewController.h
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSreachBarDelegate.h"

@protocol ShopCarViewControllerDelegate <NSObject>

-(void)hideNavigationBar;

@end

@interface ShopCarViewController : UIViewController

@property(nonatomic,assign)NSInteger userID;

@property(nonatomic,weak)id<MainSreachBarDelegate>delegate;

@property(nonatomic,weak)id<ShopCarViewControllerDelegate>navigationBarDelegate;


@end
