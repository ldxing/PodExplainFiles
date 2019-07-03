//
//  YQNotificationManager.h
//  TeacherServiceUI
//
//  Created by Yukun on 2019/6/18.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQRegisterLocalNotificationModel.h"
#import "YQUINotificationRegister.h"
#import "YQUNNotificationRegister.h"

@interface YQNotificationManager : NSObject

+ (instancetype)manager;

/**
 判断App是否有通知权限

 @param callBack 统治权限回调，grand为YES代表有权限
 */
- (void)notificationAvailable:(void (^)(BOOL granted))callBack;

/**
 注册通知

 @param infoModel 通知使用的数据，包含时间、文案内容等
 @param completeHandler 通知注册完成后的处理
 */
- (void)registerNotificationWithInfoModel:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler)completeHandler;

/**
 更新通知信息

 @param infoModel 通知使用的数据，包含时间、文案内容等
 @param completeHandler 通知注册完成后的处理
 */
- (void)updatePendingNotificationWithIdentifier:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler)completeHandler;
/**
 删除identifier的未发送通知

 @param identifier 通知的标识
 */
- (void)removePendingNotificationWithIdentifer:(NSString *)identifier;

/**
 是所有identifier的通知 并返回通知的userInfo

 @param identifier 通知的标识
 @param compledHandler 返回回调
 */
- (void)checkPendingNotificationWithIdentifier:(NSString *_Nonnull)identifier completedHandler:(YQCheckNotificationCompletedHandler _Nullable )compledHandler;
/**
 删除所有未发送通知
 */
- (void)removeAllPendingNotifications;
/**
 删除所有已发送的通知
 */
- (void)removeAllDeliveredNotifications;
/**
 删除所有过期通知
 */
- (void)clearAllLocalNotifications;
/**
 清理已过期消息 插入课程通知数据库，并删除
 */
- (void)dealingDeliveredNotification;

@end
