//
//  YQNotificationManager.m
//  TeacherServiceUI
//
//  Created by Yukun on 2019/6/18.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#import "YQNotificationManager.h"


@interface YQNotificationManager ()

@property (nonatomic, strong) id <YQNotificationRegisterProtocol> notificationRegister;

@end

@implementation YQNotificationManager

+ (instancetype)manager {
    return [[YQNotificationManager alloc] init];
}

- (void)notificationAvailable:(void (^)(BOOL granted))callBack {
    [self.notificationRegister notificationAvailable:^(BOOL granted) {
        if (callBack) {
            callBack(granted);
        }
    }];
}

- (void)registerNotificationWithInfoModel:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler)completeHandler {
    [self.notificationRegister registerLocalNotificationsWithInfoModel:infoModel completeHandler:completeHandler];
}

- (void)removePendingNotificationWithIdentifer:(NSString *)identifier {
    [self.notificationRegister removePendingNotificationWithIdentifier:identifier];
}

- (void)checkPendingNotificationWithIdentifier:(NSString *_Nonnull)identifier completedHandler:(YQCheckNotificationCompletedHandler _Nullable )compledHandler;
{
    [self.notificationRegister checkPendingNotificationWithIdentifier:identifier completedHandler:compledHandler];
}

- (void)updatePendingNotificationWithIdentifier:(YQRegisterLocalNotificationModel *)infoModel completeHandler:(YQRegisterNotificationCompleteHandler)completeHandler {
    [self.notificationRegister updatePendingNotificationWithInfoModel:infoModel completeHandler:completeHandler];
}

- (void)removeAllPendingNotifications {
    [self.notificationRegister removeAllPendingNotifications];
}

- (void)removeAllDeliveredNotifications {
    [self.notificationRegister removeAllDeliveredNotifications];
}

- (void)clearAllLocalNotifications {
    [self.notificationRegister clearAllLocalNotifications];
}

- (void)dealingDeliveredNotification
{
}
//{
//    // 数据库获取过期通知的信息
//    NSArray *array = [[YQUserInfoManager shareInstance] getNotificationsFiredBeforeTimeInterval:@(nowInterval)];
//    // 将信息筛选分类
//    NSMutableDictionary *categoryDic = [NSMutableDictionary dictionary];
//    NSMutableArray *coursesArray = [NSMutableArray array];
//    NSMutableArray *identifierArray = [NSMutableArray array];
//    for (NSDictionary *notificationInfo in array) {
//        NSNumber *type = [notificationInfo jsonNumberForKey:@"type"];
//        NSString *identifier = [notificationInfo jsonValueForKey:@"identifier"];
//        if (type.integerValue == 3 || type.integerValue == 4) {
//            NSNumber *fireTime = [notificationInfo jsonNumberForKey:@"fire_time"];
//            NSMutableDictionary *identifierDic = [categoryDic jsonValueForKey:fireTime.stringValue];
//            if (identifierDic == nil) {
//                identifierDic = [NSMutableDictionary dictionary];
//                [identifierDic setObject:type forKey:@"type"];
//                [identifierDic setObject:[notificationInfo jsonNumberForKey:@"read"] forKey:@"read"];
//                [identifierDic setObject:@([identifier integerValue]) forKey:ResponseKeyId];
//            }
//            
//            NSMutableArray *notificationCategory = [identifierDic jsonValueForKey:@"category"];
//            if (notificationCategory == nil) {
//                notificationCategory = [NSMutableArray array];
//                [notificationCategory setValue:notificationCategory forKey:@"category"];
//            }
//            
//            [notificationCategory addObject:notificationInfo];
//        } else if (type.integerValue == 2) {
//            [coursesArray addObject:notificationInfo];
//        }
//        [identifierArray addObject:identifier];
//    }
//    // 重组信息
//    NSInteger unreadMessage = 0;
//    NSMutableArray *messagesArray = [NSMutableArray array];
//    for (NSDictionary *courseNotification in coursesArray) {
//        NSInteger objcetID = [[courseNotification jsonStringForKey:@"identifier"] integerValue];
//        NSMutableDictionary *message = [NSMutableDictionary dictionary];
//        [message setObject:[courseNotification jsonStringForKey:@"alert_body"] forKey:ResponseKeyTitle];
//        [message setObject:[courseNotification jsonNumberForKey:@"fire_time"] forKey:@"send_time"];
//        [message setObject:[NSString stringWithFormat:@"%@ads.html?course_id=%@", [[YQAppConfig shareManager] deeplinkMainPath], @(objcetID)] forKey:ResponseKeyContent];
//        [message setValue:@(200000 + objcetID) forKey:ResponseKeyId];
//        NSNumber *read = [courseNotification jsonNumberForKey:@"read"];
//        [message setObject:read forKey:@"read"];
//        if (read.boolValue) {
//            unreadMessage++;
//        }
//        [messagesArray addObject:message];
//    }
//    
//    for (NSString *key in categoryDic.allKeys) {
//        NSMutableDictionary *identifierDic = [categoryDic jsonValueForKey:key];
//        NSNumber *type = [identifierDic jsonNumberForKey:@"type"];
//        NSInteger objectID = [[identifierDic jsonNumberForKey:ResponseKeyId] integerValue];
//        
//        NSMutableDictionary *message = [NSMutableDictionary dictionary];
//        [message setObject:@([key integerValue]) forKey:@"send_time"];
//        NSNumber *read = [identifierDic jsonNumberForKey:@"read"];
//        [message setObject:read forKey:@"read"];
//        if (read.boolValue) {
//            unreadMessage++;
//        }
//        if (type.integerValue == 3) {
//            [message setObject:@"您的VIP特权将于一天后过期，行乐须及时啊" forKey:ResponseKeyTitle];
//            [message setObject:@(40000 + objectID) forKey:ResponseKeyId];
//            NSArray *notificationCategory = [identifierDic jsonValueForKey:@"category"];
//            if (notificationCategory != nil && notificationCategory.count == 1) {
//                [message setObject:[NSString stringWithFormat:@"%@ads.html?privilege_id=%@",[[YQAppConfig shareManager] deeplinkMainPath], @(objectID)] forKey:ResponseKeyContent];
//            } else {
//                [message setObject:[NSString stringWithFormat:@"%@ads.html?privilege_ids", [[YQAppConfig shareManager] deeplinkMainPath]] forKey:ResponseKeyContent];
//            }
//        } else if (type.integerValue == 4) {
//            [message setObject:@"您的课程优惠券即将过期，点击查看使用" forKey:ResponseKeyTitle];
//            [message setObject:[NSString stringWithFormat:@"%@ads.html?voucher_list=11", [[YQAppConfig shareManager] deeplinkMainPath]] forKey:ResponseKeyContent];
//            [message setObject:@(40000 + objectID) forKey:ResponseKeyId];
//        }
//        [messagesArray addObject:message];
//    }
//    
//    if (messagesArray.count > 0) {
//        // 更新站内信消息
//        [[YQUserInfoManager shareInstance] updateUserMessageWithMessageArray:messagesArray];
//    }
//    
//    if (unreadMessage > 0) {
//        unreadMessage = unreadMessage + [[[YQUserInfoManager shareInstance] unreadMessageCount] integerValue];
//        [[YQUserInfoManager shareInstance] setUnreadMessagesCount:@(unreadMessage)];
//        [[NSNotificationCenter defaultCenter] postNotificationName:YQNotificationCenterCheckHasNewMessage object:@(YES)];
//    }
//    
//    // 移除已过期的通知
//    [[YQNotificationManager manager] removeAllDeliveredNotifications];
//    // 移除数据库中数据
//    [[YQUserInfoManager shareInstance] removeNotificationInfoWithIdentifiers:identifierArray];
//}

- (id<YQNotificationRegisterProtocol>)notificationRegister {
    if (_notificationRegister == nil) {
        if (@available(iOS 10.0, *))
            _notificationRegister = [[YQUNNotificationRegister alloc] init];
        else
            _notificationRegister = [[YQUINotificationRegister alloc] init];
    }
    return _notificationRegister;
}

@end
