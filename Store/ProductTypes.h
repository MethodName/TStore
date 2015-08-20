//
//  ProductTypes.h
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductTypes : NSObject

@property(nonatomic,assign)NSInteger PTID;

@property(nonatomic,strong)NSString *PTName;

@property(nonatomic,strong)NSString *PTIconUrl;

@property(nonatomic,strong)NSString *PTDesc;

@end;
