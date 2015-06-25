//
//  LogInToolClass.h
//  ShareRoad
//
//  Created by 枫叶 on 14-7-17.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogInToolClass : NSObject

@property BOOL isLogin;//是否已经登录

#pragma mark - 对外接口
+ (id)shareInstance;

#pragma -mark 保存/获取/删除用户信息
/*
 方法：保存用户信息
 参数介绍：
 参数 userInfo：  用户信息字段(比如张三)
 参数 infoType：  信息的类型（比如userName）
 */
-(void)saveUserInfo: (NSString *)userInfo AndInfoType:(NSString *)infoType;

/*
 方法：获取用户信息
 参数介绍：
 参数 infoType：  信息的类型（比如userName）
 */
- (NSString *)getUserInfo: (NSString *)infoType;

/*
 方法：移除用户信息
 参数介绍：
 参数 infoType：  信息的类型（比如userName）
 */
- (void)removeUserInfo: (NSString *)infoType;

#pragma mark - 判断是否登录
/*
 方法：保存登录
 参数介绍：
 参数 _isLogin：  YES or NO
 */
- (void)saveCookie:(BOOL)_isLogin;

/*
 方法：判断是否登录
 参数介绍：
 返回：登录返回YES; 未登录返回NO;
 */
- (BOOL)isCookie;

@end
