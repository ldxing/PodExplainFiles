//
//  YQRegisterLocalNotificationModel.h
//  TeacherServiceUI
//
//  Created by Yukun on 2019/6/18.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YQRegisterNotificationType) {
    YQRegisterNotificationTypeUnknow = 0,
    YQRegisterNotificationTypeForMock = 1,
    YQRegisterNotificationTypeForCourse = 2,
    YQRegisterNotificationTypeForVIP = 3,
    YQRegisterNotificationTypeForVoucher = 4,
};

@interface YQRegisterLocalNotificationModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *jsonData;
/*
 * @param notificationIdentifier 通知标识位
 *        课程为CourseID
 *        模考为activityID+GroupID
*/
@property (nonatomic, strong) NSString *notificationIdentifier;

@property (nonatomic, strong) NSNumber *notificationFireTime;

@property (nonatomic, strong) NSString *notificationTitle;

@property (nonatomic, strong) NSString *notificationBody;

@property (nonatomic, assign) YQRegisterNotificationType type;

@property (nonatomic, strong, readonly) NSString *notificationSoundName;

@property (nonatomic, strong) NSMutableArray *notificationIDs;

- (instancetype)initWithJsonData:(NSDictionary *)jsonData;
// 给通知添加参数，点击跳转使用
- (void)YQ_addNotificationID:(NSNumber *)notificationID;

@end
