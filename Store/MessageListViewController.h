//
//  MessageListViewController.h
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSreachBarDelegate.h"

@interface MessageListViewController : UIViewController

@property(nonatomic,weak)id<MainSreachBarDelegate>delegate;

@end
