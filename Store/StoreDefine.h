//
//  StoreDefine.h
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#ifndef Store_StoreDefine_h
#define Store_StoreDefine_h


#define NAVIGATION_ITEM_CELL 35

#define NAVIGATION_POSITION_Y 20


/**
 *【排序，筛选】隐藏自己
 */
#define HIED_SELF_TAG 0

/**
 *  筛选所有
 */
#define SCREENING_ALL_TAG 1

#define SCREENING_ALL 0


/**
 *  销量
 */
#define SORT_SCALECOUNT_TAG 11

#define SORT_SCALECOUNT "productSaleCount"


/**
 *  价格
 */
#define SORT_PRICE_TAG 12

#define SORT_PRICE  "ProductPrice"

/**
 *  上架时间
 */
#define SORT_UPDATE_TAG 13

#define SORT_UPDATE "ProductDate"


/**
 *商品列表行高
 */
#define TABLE_CELL_HEIGHT 100


/**
 *  热销商品类别编号
 */
#define PRODUCT_LIST_HOT_TYPE 0

/**
 *  排序视图开始的Y点
 */
#define SCREENINGVIEW_BEGIN_Y 120


/**
 *  排序视图隐藏的Y点
 */
#define SCREENINGVIEW_HIDE_Y -116

/**
 *  动画时间默认
 */
#define ANIMATION_TIME_DEFAULT 0.25

/**
 *  动画时间快速
 */
#define ANIMATION_TIME_QUICK 0.15

/**
 *  商品列表数据类型【正常】
 */
#define PRODUCTLIST_DATA_TYPE1 0

/**
 *  商品列表数据类型【收藏】
 */
#define PRODUCTLIST_DATA_TYPE2 1

/**
 *  最大单个购物车商品数量
 */
#define SHOP_CAR_MAX_PRODUCT_COUNT 100

/**
 *  最小单个购物车商品数量
 */
#define SHOP_CAR_MIN_PRODUCT_COUNT 1




/*
 服务器地址
 */
//#define SERVER_ROOT_PATH "http://store.hexiaotian.cn/"
#define SERVER_ROOT_PATH "http://192.168.1.114:8080/store/"
//#define SERVER_ROOT_PATH "http://10.10.52.66:8080/store/"
//#define SERVER_ROOT_PATH "http://192.168.191.1:8080/store/"
/**
 *  服务器图片根目录
 *
 */
//	#define SERVER_IMAGES_ROOT_PATH "http://store.hexiaotian.cn/images/"

#define SERVER_IMAGES_ROOT_PATH "http://192.168.1.114:8080/store/images/"



#endif
