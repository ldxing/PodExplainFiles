//
//  YQNotificationModel.h
//  TeacherServiceUI
//
//  Created by mortal on 2018/2/27.
//  Copyright © 2018年 __YiQiSchool__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQNotificationModel : NSObject

- (void)checkNotificationCompetence:(void(^)(BOOL granted))callBack;
- (void)registerLocalNotificationsWithUserInfo:(NSDictionary *)userInfo;
- (void)registerLocalNotificationWithlocalNotifications:(NSArray *)notifiactions;
//删除所有已送达消息
- (void)cancelAllDeliveredNotifications;
//删除所有未送达的消息
- (void)cancelAllPendingNotifications;
//删除所有消息
- (void)deleteAllNotifications;
- (NSString *)getAlarmSoundsWithNotificationType:(NSNumber *)type fireTime:(NSNumber *)fireTime;

@end
