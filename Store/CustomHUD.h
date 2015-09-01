//
//  CustomHUD.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHUD : UIView

@property(nonatomic,strong)UIImageView *animate;

/**
 *  获取一个加载的指示器
 *
 *  @param frame
 *
 *  @return
 */
+(id)defaultCustomHUDWithFrame:(CGRect)frame;
/**
 *  获取一个加载指示器
 *
 *  @param frame
 *
 *  @return
 */
+(id)defaultCustomHUDSimpleWithFrame:(CGRect)frame;
/**
 *  加载指示器开始加载
 */
-(void)startLoad;
/**
 *  加载指示器隐藏
 */
-(void)loadHide;
/**
 *  简单指示器开始开始加载
 */
-(void)startSimpleLoad;
/**
 *  简单指示器完成加载
 */
-(void)simpleComplete;
/**
 *  简单指示器停止加载并隐藏
 */
-(void)stopAnimation;


@end
