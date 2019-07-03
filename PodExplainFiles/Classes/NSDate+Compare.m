//
//  NSDate+Compare.m
//  TeacherServiceUI
//
//  Created by Mortal on 2017/12/26.
//  Copyright © 2017年 __YiQiSchool__. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

+ (NSComparisonResult)comparisonDateTimeIntevalWithNow:(NSNumber *)dateTimeInterVal {
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:dateTimeInterVal.longLongValue];
    NSComparisonResult result = [[self class] comparisonDateWithNow:targetDate];
    return result;
}

+ (NSComparisonResult)comparisonDateWithNow:(NSDate *)date {
    NSDate *nowDate = [NSDate date];
    NSComparisonResult result = [[self class] compareDate:date targetDate:nowDate];
    return result;
}

+ (NSComparisonResult)compareDate:(NSDate *)date targetDate:(NSDate *)targetDate {
    NSComparisonResult result = [date compare:targetDate];
    return result;
}

+ (NSInteger)transformMonthWithDate:(NSNumber *)dateNumber {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNumber.longLongValue];
    NSDateComponents *dateCom = [[self class] getDateComponentsInfo:date];
    return [dateCom month];
}

+ (NSDateComponents *)getDateComponentsInfo:(NSDate *)date {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                               NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |
                               NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday
                                          fromDate:date];
    return comps;
}

+ (TimeComparisonStatus)comparisonWithNowStartTime:(NSNumber *)startTime endTime:(NSNumber *)endTime {
                                                                                                    //开始和结束时间都不存在  长期有效
    if (startTime && !endTime) {              //没有结束时间
        if ([[self class] comparisonDateTimeIntevalWithNow:startTime] == NSOrderedDescending) {
            return TimeComparisonNotBegin;
        }
    } else if (!startTime && endTime) {       //没有开始时间
        if ([NSDate comparisonDateTimeIntevalWithNow:endTime] == NSOrderedAscending){
            return TimeComparisonHadEnded;
        }
    } else if (startTime && endTime){         //开始、结束时间都存在
        if ([[self class] comparisonDateTimeIntevalWithNow:startTime] == NSOrderedDescending) {
            return TimeComparisonNotBegin;
        } else if ([NSDate comparisonDateTimeIntevalWithNow:endTime] == NSOrderedAscending){
            return TimeComparisonHadEnded;
        }
    }
    return TimeComparisonEffetive;
}

+ (NSInteger)numberOfDaysToNowFromDateTimeInterval:(NSNumber *)fromTime {
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:fromTime.longLongValue];
    NSInteger days = [[self class] numberOfDaysFromDate:fromDate toDate:[NSDate date]];
    return MAX(((days < 0) ? -days: days), 1);
}

+ (NSInteger)numberOfDaysFromDate:(NSDate *)fromeDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromeDate toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}

@end
