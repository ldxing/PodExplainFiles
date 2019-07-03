//
//  YQLocalNotificationModel.m
//  TeacherServiceUI
//
//  Created by mortal on 2018/2/27.
//  Copyright © 2018年 __YiQiSchool__. All rights reserved.
//

#import "YQLocalNotificationModel.h"
#import "NSDate+Compare.h"

@implementation YQLocalNotificationModel

- (void)checkNotificationCompetence:(void (^)(BOOL))callBack {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    BOOL granted = YES;
    if (settings.types == UIUserNotificationTypeNone) {
        granted = NO;
    }
    callBack(granted);
}

- (void)registerLocalNotificationsWithUserInfo:(NSDictionary *)userInfo {
    NSNumber *alertTime = [userInfo objectForKey:@"fire_time"];
    NSString *alertBody = [userInfo objectForKey:@"alert_body"];
    NSString *alertTitle = [userInfo objectForKey:@"alert_title"];
    NSNumber *alertType = [userInfo objectForKey:@"notification_type"];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSince1970:alertTime.longLongValue];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    if (@available(iOS 8.2, *)) {
        notification.alertTitle = alertTitle;
    }
    notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = [self getAlarmSoundsWithNotificationType:alertType fireTime:alertTime];
    notification.userInfo = userInfo;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)registerLocalNotificationWithlocalNotifications:(NSArray *)notifiactions {
    for (NSDictionary *notification in notifiactions) {
        NSNumber *fireDate = [notification objectForKey:@"fire_time"];
        if ([NSDate comparisonDateTimeIntevalWithNow:fireDate] == NSOrderedDescending) {
            [self registerLocalNotificationsWithUserInfo:notification];
        }
    }
}

//删除所有未送达的消息
- (void)cancelAllPendingNotifications {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSNumber *alertTime = [userInfo objectForKey:@"fire_time"];
            if ([NSDate comparisonDateTimeIntevalWithNow:alertTime] != NSOrderedAscending) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}
//删除所有已送达消息
- (void)cancelAllDeliveredNotifications {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSNumber *alertTime = [userInfo objectForKey:@"fire_time"];
            if ([NSDate comparisonDateTimeIntevalWithNow:alertTime] == NSOrderedAscending) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

- (void)deleteAllNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
