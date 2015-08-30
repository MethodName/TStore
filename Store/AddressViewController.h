//
//  AddressViewController.h
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressViewControllerDelegate <NSObject>

-(void)selectRowWithProvinceCityDistrict:(NSString *)provinceCityDistrict AddressDetail:(NSString *)addressDetail Consignee:(NSString *)consignee  Telephone:(NSString*) telephone;

@end

@interface AddressViewController : UIViewController

@property(nonatomic,weak)id<AddressViewControllerDelegate>delegate;


@end
