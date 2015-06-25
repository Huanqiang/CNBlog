//
//  LogInToolClass.m
//  ShareRoad
//
//  Created by 枫叶 on 14-7-17.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "LogInToolClass.h"

@implementation LogInToolClass
@synthesize isLogin;

static LogInToolClass *instnce;
#pragma mark - 对外接口
//使外部文件可以直接访问UesrDB内部函数
+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}

#pragma -mark 保存/获取/删除用户信息
- (void)saveUserInfo: (NSString *)userInfo AndInfoType:(NSString *)infoType {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:infoType];
    [settings setObject:userInfo forKey:infoType];
    [settings synchronize];
}

- (NSString *)getUserInfo: (NSString *)infoType {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *userInfo = [settings objectForKey:infoType];
    return userInfo;
}

- (void)removeUserInfo: (NSString *)infoType {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:infoType];
    [settings synchronize];
}


#pragma mark - 判断是否登录
-(void)saveCookie:(BOOL)_isLogin {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"MyCookie"];
    [setting setObject:_isLogin ? @"1" : @"0" forKey:@"MyCookie"];
    [setting synchronize];
}

- (BOOL)isCookie {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"MyCookie"];
    if (value && [value isEqualToString:@"1"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}




@end
