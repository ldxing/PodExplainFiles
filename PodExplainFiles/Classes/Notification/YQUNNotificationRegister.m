//
//  YQUNNotificationRegister.m
//  TeacherServiceUI
//
//  Created by Yukun on 2019/6/18.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#import "YQUNNotificationRegister.h"
#import <UserNotifications/UserNotifications.h>
#import "NSDate+Compare.h"

@implementation YQUNNotificationRegister

- (void)notificationAvailable:(void (^)(BOOL))callBack __IOS_AVAILABLE(10.0) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                             UNAuthorizationOptionSound |
                                             UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        callBack(granted);
    }];
}

- (void)registerLocalNotificationWithlocalNotificationModels:(NSArray<YQRegisterLocalNotificationModel *> *)notifiactionModels {
    for (YQRegisterLocalNotificationModel *model in notifiactionModels) {
        [self registerLocalNotificationsWithInfoModel:model completeHandler:nil];
    }
}

- (void)registerLocalNotificationsWithInfoModel:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler)completeHandler __IOS_AVAILABLE(10.0) {
    
    if ([NSDate comparisonDateTimeIntevalWithNow:infoModel.notificationFireTime] == NSOrderedAscending) {
        return;
    }
    
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:(infoModel.notificationTitle ?: @"一起考教师") arguments:nil];
    if (infoModel.notificationBody) {
        content.body = [NSString localizedUserNotificationStringForKey:infoModel.notificationBody
                                                             arguments:nil];
    }
    content.sound = [UNNotificationSound soundNamed:infoModel.notificationSoundName];
    content.badge = @1;
    content.userInfo = infoModel.jsonData;

    NSDate *fireDate = [NSDate dateWithTimeIntervalSince1970:infoModel.notificationFireTime.longLongValue];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitDay fromDate:fireDate];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:infoModel.notificationIdentifier content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
#ifdef DEBUG
        NSLog(@"Notification Register %@", (error != nil) ? @"Failed" : @"Success");
#endif
        if (completeHandler) {
            completeHandler(error);
        }
    }];
}

- (void)removeAllDeliveredNotifications __IOS_AVAILABLE(10.0) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
}

- (void)removeAllPendingNotifications __IOS_AVAILABLE(10.0) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
}

- (void)clearAllLocalNotifications {
    [self removeAllDeliveredNotifications];
    [self removeAllPendingNotifications];
}

- (void)removePendingNotificationWithIdentifier:(NSString *)identifier __IOS_AVAILABLE(10.0) {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
}

- (void)checkPendingNotificationWithIdentifier:(NSString *)identifier completedHandler:(YQCheckNotificationCompletedHandler _Nullable)compledHandler  __IOS_AVAILABLE(10.0) {
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            if ([request.identifier isEqualToString:identifier]) {
                if (compledHandler) {
                    compledHandler(request.content.userInfo);
                }
                break;
            }
        }
    }];
}

- (void)updatePendingNotificationWithInfoModel:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler _Nullable)completeHandler __IOS_AVAILABLE(10.0) {
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            if ([request.identifier isEqualToString:infoModel.notificationIdentifier]) {
                [self removePendingNotificationWithIdentifier:infoModel.notificationIdentifier];
                if ([NSDate comparisonDateTimeIntevalWithNow:infoModel.notificationFireTime] == NSOrderedDescending) {
                    [self registerLocalNotificationsWithInfoModel:infoModel completeHandler:completeHandler];
                }
                break;
            }
        }
    }];
}



@end
