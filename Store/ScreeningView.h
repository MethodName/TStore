//
//  ScreeningView.h
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProductDelegate.h"

@interface ScreeningView : UIView

@property(nonatomic,strong)UIView *sView;

@property(nonatomic,weak)id<SearchProductDelegate>delegate;



@end
