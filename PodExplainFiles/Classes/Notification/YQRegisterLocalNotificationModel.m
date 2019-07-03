//
//  YQRegisterLocalNotificationModel.m
//  TeacherServiceUI
//
//  Created by Yukun on 2019/6/18.
//  Copyright © 2019 __YiQiSchool__. All rights reserved.
//

#import "YQRegisterLocalNotificationModel.h"
#import "NSDate+Compare.h"

@interface YQRegisterLocalNotificationModel ()

@property (nonatomic, strong, readwrite) NSString *notificationSoundName;

@end

@implementation YQRegisterLocalNotificationModel
@synthesize notificationIdentifier = _notificationIdentifier;
@synthesize notificationFireTime = _notificationFireTime;
@synthesize notificationBody = _notificationBody;
@synthesize notificationTitle = _notificationTitle;
//@synthesize notificationGroupID = _notificationGroupID;
//@synthesize notificationActivityID = _notificationActivityID;
@synthesize type = _type;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.jsonData = [NSMutableDictionary dictionary];
        self.notificationIDs = [NSMutableArray array];
        [self.jsonData setValue:self.notificationIDs forKey:@"notification_ids"];
    }
    return self;
}

- (instancetype)initWithJsonData:(NSDictionary *)jsonData {
    self = [super init];
    if (self) {
        self.jsonData = [NSMutableDictionary dictionaryWithDictionary:jsonData];
        self.notificationIDs = [self.jsonData valueForKey:@"notification_ids"];
    }
    return self;
}

- (NSString *)notificationIdentifier {
    if (_notificationIdentifier == nil) {
        _notificationIdentifier = [self.jsonData valueForKey:@"identifier"];
    }
    return _notificationIdentifier;
}

- (void)setNotificationIdentifier:(NSString *)notificationIdentifier {
    _notificationIdentifier = notificationIdentifier;
    [self.jsonData setValue:notificationIdentifier forKey:@"identifier"];
}

- (NSNumber *)notificationFireTime {
    if (_notificationFireTime == nil) {
        _notificationFireTime = [self.jsonData valueForKey:@"fire_time"];
    }
    return _notificationFireTime;
}

- (void)setNotificationFireTime:(NSNumber *)notificationFireTime {
    _notificationFireTime = notificationFireTime;
    [self.jsonData setValue:notificationFireTime forKey:@"fire_time"];
}

- (NSString *)notificationTitle {
    if (_notificationTitle == nil) {
        _notificationTitle = [self.jsonData valueForKey:@"alert_title"];
    }
    return _notificationTitle;
}

- (void)setNotificationTitle:(NSString *)notificationTitle {
    _notificationTitle = notificationTitle;
    [self.jsonData setValue:notificationTitle forKey:@"alert_title"];
}

- (NSString *)notificationBody {
    if (_notificationBody == nil) {
        _notificationBody = [self.jsonData valueForKey:@"alert_body"];
    }
    return _notificationBody;
}

- (void)setNotificationBody:(NSString *)notificationBody {
    _notificationBody = notificationBody;
    [self.jsonData setValue:notificationBody forKey:@"alert_body"];
}

- (void)YQ_addNotificationID:(NSNumber *)notificationID {
    [self.notificationIDs addObject:notificationID];
}

- (NSString *)notificationSoundName {
    if (_notificationSoundName == nil && self.type != YQRegisterNotificationTypeUnknow && self.notificationFireTime != nil) {
        if (self.type == YQRegisterNotificationTypeForMock) {
            NSInteger fireTimeMonth = [NSDate transformMonthWithDate:self.notificationFireTime];
            return ((fireTimeMonth % 2) == 0) ? @"mock_alarm_xumeijing.mp3": @"mock_alarm_wanglike.mp3";
        } else {
            return UILocalNotificationDefaultSoundName;
        }
    }
    return _notificationSoundName;
}

- (YQRegisterNotificationType)type {
    if (_type == YQRegisterNotificationTypeUnknow) {
        _type = [[self.jsonData valueForKey:@"notification_type"] integerValue];
    }
    return _type;
}

- (void)setType:(YQRegisterNotificationType)type {
    _type = type;
    [self.jsonData setValue:@(type) forKey:@"notification_type"];
}

@end
