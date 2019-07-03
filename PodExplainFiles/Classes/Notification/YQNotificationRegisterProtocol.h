//
//  YQNotificationRegisterProtocol.h
//  TeacherServiceUI
//
//  Created by Yukun on 2019/6/18.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQRegisterLocalNotificationModel.h"

typedef void(^YQRegisterNotificationCompleteHandler)(NSError * _Nullable error);

typedef void(^YQCheckNotificationCompletedHandler) (NSDictionary * _Nullable notificationUserInfo);

@protocol YQNotificationRegisterProtocol <NSObject>
// 查看通知权限
- (void)notificationAvailable:(void(^_Nullable)(BOOL granted))callBack;
// 注册单个本地通知
- (void)registerLocalNotificationsWithInfoModel:(YQRegisterLocalNotificationModel * _Nonnull)infoModel completeHandler:(YQRegisterNotificationCompleteHandler _Nullable )completeHandler;
// 批量注册本地通知
- (void)registerLocalNotificationWithlocalNotificationModels:(NSArray <YQRegisterLocalNotificationModel *>*_Nullable)notifiactionModels;
// 删除所有已送达消息
- (void)removeAllDeliveredNotifications;
// 删除所有未送达的消息
- (void)removeAllPendingNotifications;
// 移除与identifier匹配的未发送通知
- (void)removePendingNotificationWithIdentifier:(NSString * _Nonnull)identifier;

- (void)checkPendingNotificationWithIdentifier:(NSString *_Nonnull)identifier completedHandler:(YQCheckNotificationCompletedHandler _Nullable )compledHandler;
// 更新与infoModel匹配的未发送通知
- (void)updatePendingNotificationWithInfoModel:(YQRegisterLocalNotificationModel * _Nonnull)infoModel completeHandler:(YQRegisterNotificationCompleteHandler _Nullable )completeHandler;
//删除所有消息
- (void)clearAllLocalNotifications;

@end
