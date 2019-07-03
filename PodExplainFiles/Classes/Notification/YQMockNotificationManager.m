//
//  YQMockNotificationManager.m
//  TeacherServiceUI
//
//  Created by mortal on 2018/2/27.
//  Copyright © 2018年 __YiQiSchool__. All rights reserved.
//

#import "YQMockNotificationManager.h"
#import "YQLocalNotificationModel.h"
#import "YQNotificationCenterModel.h"

@implementation YQMockNotificationManager

+ (void)checkNotificationCompetence:(void(^)(BOOL granted))callBack {
    YQNotificationModel *model = [YQMockNotificationManager getNotificationModel];
    [model checkNotificationCompetence:^(BOOL granted) {
        callBack(granted);
    }];
}

+ (void)registerMockNotificationWithUserInfo:(NSDictionary *)userInfoDic {
    YQNotificationModel *model = [YQMockNotificationManager getNotificationModel];
    [model registerLocalNotificationsWithUserInfo:userInfoDic];
}

+ (void)registerMockNotificationWithlocalNotifications:(NSArray *)localNotifications {
    YQNotificationModel *model = [YQMockNotificationManager getNotificationModel];
    [model registerLocalNotificationWithlocalNotifications:localNotifications];
}

+ (void)cancelPassedMockNotification {
    YQNotificationModel *model = [YQMockNotificationManager getNotificationModel];
    [model cancelAllDeliveredNotifications];
}

+ (void)deleteALllMockNotification {
    YQNotificationModel *model = [YQMockNotificationManager getNotificationModel];
    [model deleteAllNotifications];
}

+ (YQNotificationModel *)getNotificationModel {
    YQNotificationModel *model;
    if (@available(iOS 10.0, *))
        model = [[YQNotificationCenterModel alloc] init];
    else
        model = [[YQLocalNotificationModel alloc] init];
    return model;
}

@end
