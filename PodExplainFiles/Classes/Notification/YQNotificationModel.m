//
//  YQNotificationModel.m
//  TeacherServiceUI
//
//  Created by mortal on 2018/2/27.
//  Copyright © 2018年 __YiQiSchool__. All rights reserved.
//

#import "YQNotificationModel.h"
#import "NSDate+Compare.h"

#define WANGLIKEMP3 @"mock_alarm_wanglike.mp3"
#define XUMEIJINGMP3 @"mock_alarm_xumeijing.mp3"

@implementation YQNotificationModel

- (void)checkNotificationCompetence:(void (^)(BOOL))callBack {
    
}

- (void)registerLocalNotificationsWithUserInfo:(NSDictionary *)userInfo{
    
}

- (void)registerLocalNotificationWithlocalNotifications:(NSArray *)notifiactions {
    
}

- (void)cancelAllDeliveredNotifications {
    
}

- (void)cancelAllPendingNotifications {
    
}

- (void)deleteAllNotifications {
    
}

- (NSString *)getAlarmSoundsWithNotificationType:(NSNumber *)type fireTime:(NSNumber *)fireTime {
    if ([type isEqual:@1]) {
        NSInteger fireTimeMonth = [NSDate transformMonthWithDate:fireTime];
        return ((fireTimeMonth % 2) == 0) ? XUMEIJINGMP3: WANGLIKEMP3;
    }
    return UILocalNotificationDefaultSoundName;
}

@end
