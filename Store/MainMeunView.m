//
//  MainMeunView.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MainMeunView.h"
#import "MainMenuItem.h"
#import "StoreDefine.h"
#import "ProductTypes.h"
#import "ToolsOriginImage.h"


@implementation MainMeunView

#pragma mark -初始化方法
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    [self setBackgroundColor:[UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1.0]];
    self.dView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [self.dView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.dView];
    //固定第一个热门推荐类型
    MainMenuItem *hotBtn = [MainMenuItem buttonWithType:UIButtonTypeCustom];
    [hotBtn setFrame:CGRectMake(0, 0, 80, 80)];
     UIImage *img =[UIImage imageWithCGImage:[[UIImage imageNamed:@"tuijian"] CGImage] scale:1.8 orientation:UIImageOrientationUp];
    [hotBtn setImage:img forState:0];
    [hotBtn setTitle:@"热门推荐" forState:0];
    [hotBtn setTitleColor:[UIColor grayColor] forState:0];
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    hotBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    hotBtn.tag = PRODUCT_LIST_HOT_TYPE;//热门推荐
    //添加点击事件
    [hotBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.dView addSubview:hotBtn];
    return self;
}

#pragma mark -设置类型
-(void)setMenuItems:(NSArray *)menuItems
{
    CGFloat width = self.frame.size.width;
    //CGFloat height = self.frame.size.height;
    NSInteger maxRow = (menuItems.count+1)/4+1;
    //根据商品类别的个数，重新确定view大小
    [self.dView setFrame:CGRectMake(self.dView.frame.origin.x, self.dView.frame.origin.y, self.dView.frame.size.width, self.dView.frame.size.height*maxRow)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height*maxRow)];
   // NSLog(@"%d  %d",(int)menuItems.count,(int)row);
    for (int i =0; i<menuItems.count; i++)
    {
        
        ProductTypes *type = menuItems[i];
        MainMenuItem *hotBtn = [MainMenuItem buttonWithType:UIButtonTypeCustom];
        int index = (i+1)%4;
        int row = (i+1)/4;
        CGFloat x= index*width/4;
        CGFloat y =row*80;
        
        [hotBtn setFrame:CGRectMake(x, y, 80, 80)];
        
        //确定图片的路径
        NSString *path =[NSString stringWithFormat:@"%s%@",SERVER_IMAGES_ROOT_PATH,type.ptIconUrl];
        
        //NSLog(@"%@",path);
        NSURL *photourl = [NSURL URLWithString:path];
//        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //通过网络url获取uiimage
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                  [hotBtn setImage: [ToolsOriginImage OriginImage:img scaleToSize:CGSizeMake(50, 50)] forState:0];
            });
            
        });
        
//         UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
//           [hotBtn setImage: [ToolsOriginImage OriginImage:img scaleToSize:CGSizeMake(50, 50)] forState:0];
        [hotBtn setTitle:type.ptName forState:0];
        [hotBtn setTitleColor:[UIColor grayColor] forState:0];
        //将类型ID放入tag中，方便后面取值
        [hotBtn setTag:type.ptID];
        hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        hotBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        
        
        //[hotBtn setCenter:CGPointMake(width/4*index + width/8, height/2)];
        //添加点击事件
        [hotBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.dView addSubview:hotBtn];
    }
}

#pragma mark -类别按钮点击事件
-(void)typeBtnClick:(UIButton *)typeBtn
{
    //通知父级
    [_delegate productListWithType:typeBtn.tag];
}



@end
