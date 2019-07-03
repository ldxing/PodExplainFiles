//
//  NSDate+Compare.h
//  TeacherServiceUI
//
//  Created by Mortal on 2017/12/26.
//  Copyright © 2017年 __YiQiSchool__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TimeComparisonStatus) {
    TimeComparisonNotBegin,
    TimeComparisonEffetive,
    TimeComparisonHadEnded,
};

@interface NSDate (Compare)

+ (NSComparisonResult)comparisonDateTimeIntevalWithNow:(NSNumber *)dateTimeInterVal;
+ (NSComparisonResult)comparisonDateWithNow:(NSDate *)date;
+ (NSInteger)transformMonthWithDate:(NSNumber *)dateNumber;
+ (NSDateComponents *)getDateComponentsInfo:(NSDate *)date;
+ (TimeComparisonStatus)comparisonWithNowStartTime:(NSNumber *)startTime endTime:(NSNumber *)endTime;
+ (NSInteger)numberOfDaysToNowFromDateTimeInterval:(NSNumber *)fromTime;

@end
