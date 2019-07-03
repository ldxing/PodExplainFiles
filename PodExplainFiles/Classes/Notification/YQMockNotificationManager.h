//
//  YQMockNotificationManager.h
//  TeacherServiceUI
//
//  Created by mortal on 2018/2/27.
//  Copyright © 2018年 __YiQiSchool__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQMockNotificationManager : NSObject

+ (void)checkNotificationCompetence:(void(^)(BOOL granted))callBack;
/**
 @abstract 注册本地通知
 
 @userInfoKeys :
 @require
 alert_body 通知内容
 channel   通知渠道来源  模考/客服/
 fire_time 通知时间
 @optional
 @activity_id
 @group_id
 */
+ (void)registerMockNotificationWithUserInfo:(NSDictionary *)userInfoDic;
+ (void)registerMockNotificationWithlocalNotifications:(NSArray *)localNotifications;
//清除过时本地通知
+ (void)cancelPassedMockNotification;
//清除所有本地通知
+ (void)deleteALllMockNotification;

@end
