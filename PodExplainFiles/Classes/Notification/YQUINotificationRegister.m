//
//  YQUINotificationRegister.m
//  TeacherServiceUI
//
//  Created by Yukun on 2019/6/18.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#import "YQUINotificationRegister.h"
#import "NSDate+Compare.h"

@implementation YQUINotificationRegister

- (void)notificationAvailable:(void (^)(BOOL))callBack {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    BOOL granted = YES;
    if (settings.types == UIUserNotificationTypeNone) {
        granted = NO;
    }
    callBack(granted);
}

- (void)registerLocalNotificationWithlocalNotificationModels:(NSArray<YQRegisterLocalNotificationModel *> *)notifiactionModels {
    for (YQRegisterLocalNotificationModel *model in notifiactionModels) {
        [self registerLocalNotificationsWithInfoModel:model completeHandler:nil];
    }
}

- (void)registerLocalNotificationsWithInfoModel:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler)completeHandler {
    
    if ([NSDate comparisonDateTimeIntevalWithNow:infoModel.notificationFireTime] == NSOrderedAscending) {
        return;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSince1970:infoModel.notificationFireTime.longLongValue];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    if (@available(iOS 8.2, *)) {
        
        notification.alertTitle = infoModel.notificationTitle ?: @"一起考教师";
        if (infoModel.notificationBody != nil) {
            notification.alertBody = infoModel.notificationBody;
        }
    } else {
        notification.alertBody = infoModel.notificationBody;
    }
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = infoModel.notificationSoundName;
    notification.userInfo = infoModel.jsonData;
    if (infoModel.notificationIdentifier != nil) {
        notification.category = infoModel.notificationIdentifier;
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    if (completeHandler) {
        completeHandler(nil);
    }
}

- (void)removeAllPendingNotifications {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        YQRegisterLocalNotificationModel *model = [[YQRegisterLocalNotificationModel alloc] initWithJsonData:notification.userInfo];
        if (model && model.notificationFireTime) {
            if ([NSDate comparisonDateTimeIntevalWithNow:model.notificationFireTime] != NSOrderedAscending) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

- (void)removeAllDeliveredNotifications {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        YQRegisterLocalNotificationModel *model = [[YQRegisterLocalNotificationModel alloc] initWithJsonData:notification.userInfo];
        if (model && model.notificationFireTime) {
            if ([NSDate comparisonDateTimeIntevalWithNow:model.notificationFireTime] == NSOrderedAscending) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

- (void)clearAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)removePendingNotificationWithIdentifier:(NSString *)identifier {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        if ([notification.category isEqualToString:identifier]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}

- (void)checkPendingNotificationWithIdentifier:(NSString *)identifier completedHandler:(YQCheckNotificationCompletedHandler _Nullable)compledHandler
{
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        if ([notification.category isEqualToString:identifier]) {
            if (compledHandler) {
                compledHandler(notification.userInfo);
            }
            break;
        }
    }
}

- (void)updatePendingNotificationWithInfoModel:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler _Nullable)completeHandler {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        if ([notification.category isEqualToString:infoModel.notificationIdentifier]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            if ([NSDate comparisonDateTimeIntevalWithNow:infoModel.notificationFireTime] == NSOrderedDescending) {
                [self registerLocalNotificationsWithInfoModel:infoModel completeHandler:completeHandler];
            }
            break;
        }
    }
}
@end
