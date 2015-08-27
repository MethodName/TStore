//
//  ProductTypes.h
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductTypes : NSObject

@property(nonatomic,assign)NSInteger pmcID;

@property(nonatomic,assign)NSInteger ptID;

@property(nonatomic,strong)NSString *ptName;

@property(nonatomic,strong)NSString *ptIconUrl;

@property(nonatomic,assign)NSInteger ptParentID;

@end;
