//
//  MainMeunView.h
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainMeunViewDelegate <NSObject>

-(void)productListWithType:(NSInteger)type;

@end

@interface MainMeunView : UIView

@property(nonatomic,weak)id<MainMeunViewDelegate>delegate;

-(void)setMenuItems:(NSArray *)menuItems;

@end
