//
//  CustomHUD.m
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "CustomHUD.h"

@interface CustomHUD()

@property(nonatomic,strong)NSMutableArray *imagesLoading1;

@property(nonatomic,strong)NSMutableArray *imagesLoading2;

@property(nonatomic,strong)NSMutableArray *imagesComplete;

@end

@implementation CustomHUD

+(id)defaultCustomHUDWithFrame:(CGRect)frame
{
    CustomHUD *hud = [[CustomHUD alloc]initWithFrame:frame];
    [hud setBackgroundColor:[UIColor whiteColor]];
    hud.animate = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width*0.4, frame.size.width*0.38)];
    [hud.animate setCenter:hud.center];
    [hud.animate setAnimationDuration:1.5];
    [hud.animate setAnimationRepeatCount:100000000];
    [hud addSubview:hud.animate];
    return hud;
}



+(id)defaultCustomHUDSimpleWithFrame:(CGRect)frame
{
    CustomHUD *hud = [[CustomHUD alloc]initWithFrame:frame];
    [hud setBackgroundColor:[UIColor colorWithRed:(100/255.0) green:(100/255.0) blue:(100/255.0) alpha:0.7]];
    hud.animate = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width*0.3, frame.size.width*0.31)];
    [hud.animate setCenter:hud.center];
    [hud addSubview:hud.animate];
    [hud.animate.layer setCornerRadius:5.0];
    [hud.animate setClipsToBounds:YES];
    return hud;
}


-(void)startLoad
{
    NSMutableArray *images = [NSMutableArray new];
    for (int i =0; i<28; i++) {
        NSString *path =[NSString stringWithFormat:@"Image.bundle/loading/%d.png",i+1];
        UIImage *img =[UIImage imageNamed:path];
        [images addObject:img];
    }
    [self.animate setAnimationImages:images];
    [self.animate setAnimationDuration:2.5];
    [self.animate setAnimationRepeatCount:99999999];
    [self.animate startAnimating];
}

-(void)startSimpleLoad
{
    NSMutableArray *images = [NSMutableArray new];
    for (int i =0; i<50; i++) {
        NSString *path =[NSString stringWithFormat:@"Image.bundle/loading2/%d.png",i+1];
        UIImage *img =[UIImage imageNamed:path];
        [images addObject:img];
    }
    [self.animate setAnimationImages:images];
    [self.animate setAnimationDuration:2.5];
    [self.animate setAnimationRepeatCount:999999999];
    [self.animate startAnimating];
}

#pragma mark -完成动画后隐藏
-(void)simpleComplete
{
    NSMutableArray *images = [NSMutableArray new];
    for (int i =68; i<102; i++) {
        NSString *path =[NSString stringWithFormat:@"Image.bundle/loading2/%d.png",i];
        UIImage *img =[UIImage imageNamed:path];
        [images addObject:img];
    }
    [self.animate stopAnimating];
    [self.animate setAnimationImages:images];
    [self.animate setAnimationDuration:1.0];
    [self.animate setAnimationRepeatCount:1];
    [self.animate startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    sleep(1.0);
        dispatch_async(dispatch_get_main_queue(), ^
       {
          [self setHidden:YES];
       });
    });
}

#pragma mark -加载后隐藏
-(void)loadHide
{
   [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^
    {
        [self.layer setOpacity:0.1];
    }
    completion:^(BOOL finished)
    {
        [self setHidden:YES];
    }];
    
}





@end
