//
//  CustomAnimate.h
//  Store
//
//  Created by tangmingming on 15/9/2.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomAnimate : NSObject

/**
 *  缩放动画
 *
 *  @param view               视图
 *  @param fromVale       开始值
 *  @param toVlaue          变化值
 *  @param duration         动画时间
 *  @param autoreverses 是否还原
 *  @param repeatCount  重复次数
 */
+(void)scaleAnime:(UIView *)view FromValue:(float)fromVale ToValue:(float)toVlaue Duration:(float)duration Autoreverse:(BOOL)autoreverses RepeatCount:(float)repeatCount;

/**
 *  缩放动画【透明】
 *
 *  @param view             视图
 *  @param fromVale     开始值
 *  @param toVlaue         变化值
 *  @param duration         动画时间
 *  @param autoreverses     是否还原
 *  @param repeatCount      重复次数
 */
+(void)scaleOpacityAnime:(UIView *)view FromValue:(float)fromVale ToValue:(float)toVlaue Duration:(float)duration Autoreverse:(BOOL)autoreverses RepeatCount:(float)repeatCount;

/**
 *  晃动动画
 *
 *  @param view         视图
 *  @param fromVale     开始值
 *  @param toVlaue      变化值
 *  @param duration     动画时间
 *  @param autoreverses 是否还原
 *  @param repeatCount  重复次数
 */
+(void)shake:(UIView *)view FromValue:(float)fromVale ToValue:(float)toVlaue Duration:(float)duration Autoreverse:(BOOL)autoreverses RepeatCount:(float)repeatCount;

@end
