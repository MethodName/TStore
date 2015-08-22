//
//  ADScrollVIew.h
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSreachBarDelegate.h"

@protocol MainADScrollVIewDelegate <NSObject>

-(void)imageMoveWithIndex:(NSInteger)index;

@end


@interface MainADScrollVIew : UIScrollView

@property(nonatomic,weak)id<MainSreachBarDelegate>sreachBarDelegate;

@property(nonatomic,weak)id<MainADScrollVIewDelegate>imageMoveDelegate;


-(void)setImages:(NSArray *)imageArray;

@end
