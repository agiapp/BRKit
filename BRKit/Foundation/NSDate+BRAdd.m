//
//  NSDate+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSDate+BRAdd.h"
#import "BRKitMacro.h"

BRSYNTH_DUMMY_CLASS(NSDate_BRAdd)

@implementation NSDate (BRAdd)

#pragma mark - 获取系统当前的时间戳，即当前时间距1970的秒数（以毫秒为单位）
+ (NSString *)br_timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    /** 当前时间距1970的秒数。*1000 是精确到毫秒，不乘就是精确到秒 */
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
    
    return timeString;
}

#pragma mark - 获取当前的时间
+ (NSString *)br_currentDateString {
    return [self br_currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)br_currentDateStringWithFormat:(NSString *)formatterStr {
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}

#pragma mark - 返回指定时间差值的日期字符串
+ (NSString *)br_dateStringWithDelta:(NSTimeInterval)delta {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:delta];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

#pragma mark - 返回日期格式字符串  @"2016-10-16 14:30:30"  @"yyyy-MM-dd HH:mm:ss"
// 注意：一个日期字符串必须 与 它相应的日期格式对应，这个才能被系统识别为日期
+ (NSString *)br_dateDescriptionWithTargetDate:(NSString *)dateStr andTargetDateFormat:(NSString *)dateFormatStr {
    // 1.获取当前时间
    NSDate *currentDate = [NSDate date];
    // 2.目标时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormatStr;
    NSDate *targetDate = [formatter dateFromString:dateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *returnFormatter = [[NSDateFormatter alloc] init];
    if ([calendar isDate:targetDate equalToDate:currentDate toUnitGranularity:NSCalendarUnitYear]) {
        if ([calendar isDateInToday:targetDate]) {
            NSDateComponents *components = [calendar components:NSCalendarUnitMinute | NSCalendarUnitHour fromDate:targetDate toDate:currentDate options:0];
            if (components.hour == 0) {
                if (components.minute == 0) {
                    return @"刚刚";
                } else {
                    return [NSString stringWithFormat:@"%ld分钟前", (long)components.minute];
                }
            } else {
                return [NSString stringWithFormat:@"%ld小时前", (long)components.hour];
            }
        } else if ([calendar isDateInYesterday:targetDate]) {
            return @"昨天";
        } else {
            returnFormatter.dateFormat = @"M-d";
            return [returnFormatter stringFromDate:targetDate];
        }
    } else {
        returnFormatter.dateFormat = @"yyyy-M-d";
        return [returnFormatter stringFromDate:targetDate];
    }
    return nil;
}

@end
