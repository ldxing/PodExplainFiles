//
//  YQNotificationCenterModel.m
//  TeacherServiceUI
//
//  Created by mortal on 2018/2/27.
//  Copyright © 2018年 __YiQiSchool__. All rights reserved.
//

#import "YQNotificationCenterModel.h"
#import <UserNotifications/UserNotifications.h>
//#import "NSDate+Category.h"
#import "NSDate+Compare.h"

@implementation YQNotificationCenterModel

- (void)checkNotificationCompetence:(void (^)(BOOL))callBack __IOS_AVAILABLE(10.0) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                             UNAuthorizationOptionSound |
                                             UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        callBack(granted);
    }];
}

- (void)registerLocalNotificationsWithUserInfo:(NSDictionary *)userInfo __IOS_AVAILABLE(10.0) {
    
    NSNumber *alertTime = [userInfo objectForKey:@"fire_time"];
    NSString *alertBody = [userInfo objectForKey:@"alert_body"];
    NSString *alertTitle = [userInfo objectForKey:@"alert_title"];
    NSNumber *alertType = [userInfo objectForKey:@"notification_type"];
    NSNumber *groupID = [userInfo objectForKey:@"group_id"];
    NSNumber *activityID = [userInfo objectForKey:@"activity_id"];
        
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:alertTitle arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:alertBody
                                                         arguments:nil];
    content.sound = [UNNotificationSound soundNamed:[self getAlarmSoundsWithNotificationType:alertType fireTime:alertTime]];
    content.badge = @1;
    content.userInfo = userInfo;
    
    long long timeInterval = alertTime.longLongValue - [[NSDate date] timeIntervalSince1970];
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%@%@", activityID, groupID] content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
#ifdef DEBUG
        NSLog(@"%@", (error != nil) ? @"failed" : @"success");
#endif
    }];
}

- (void)registerLocalNotificationWithlocalNotifications:(NSArray *)notifiactions {
    for (NSDictionary *notification in notifiactions) {
        NSNumber *fireDate = [notification objectForKey:@"fire_time"];
        if ([NSDate comparisonDateTimeIntevalWithNow:fireDate] == NSOrderedDescending) {
            [self registerLocalNotificationsWithUserInfo:notification];
        }
    }
}

- (void)cancelAllDeliveredNotifications __IOS_AVAILABLE(10.0) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
}

- (void)cancelAllPendingNotifications __IOS_AVAILABLE(10.0) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
}

- (void)deleteAllNotifications {
    [self cancelAllDeliveredNotifications];
    [self cancelAllPendingNotifications];
}

@end
