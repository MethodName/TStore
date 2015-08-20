//
//  SortView.h
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProductDelegate.h"

@interface SortView : UIView

@property(nonatomic,weak)id<SearchProductDelegate>delegate;

@end
