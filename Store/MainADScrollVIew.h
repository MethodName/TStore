//
//  ADScrollVIew.h
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSreachBarDelegate.h"


@interface MainADScrollVIew : UIScrollView

@property(nonatomic,weak)id<MainSreachBarDelegate>sreachBarDelegate;


-(void)setImages:(NSArray *)imageArray;

@end
