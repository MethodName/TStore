//
//  ProductListTableViewController.h
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSreachBarDelegate.h"


@interface ProductListTableViewController : UIViewController

@property(nonatomic,weak)id<MainSreachBarDelegate>delegate;

@end
