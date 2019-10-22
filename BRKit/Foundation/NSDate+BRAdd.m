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

#pragma mark - 按指定格式返回时间字符串
+ (NSString *)br_dateString:(NSString *)dateString oldFormat:(NSString *)oldFormat newFormat:(NSString *)newFormat {
    // 获取系统当前时间
    NSDate *oldDate = [self br_getDate:dateString format:oldFormat];
    // 用于格式化 NSDate 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = newFormat;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *newDateString = [formatter stringFromDate:oldDate];
    // 输出 newDateString
    return newDateString;
}

#pragma mark - 日期和字符串之间的转换：NSDate --> NSString
+ (NSString *)br_getDateString:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = format;
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma mark - 日期和字符串之间的转换：NSString --> NSDate
+ (NSDate *)br_getDate:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = format;
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark - 返回指定时间差值的日期字符串
+ (NSString *)br_dateStringWithDelta:(NSTimeInterval)delta {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:delta];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

/**
 * @method
 *
 * @brief 获取两个日期之间的天数
 * @param fromDate       起始日期
 * @param toDate         终止日期
 * @return    总天数
 */
+ (NSInteger)br_numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}

/**
 计算两个时间相差多少天多少小时多少分多少秒

 @param startTime 开始时间
 @param endTime 结束时间
 @return 时间差
 */
- (NSString *)br_dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate =[date dateFromString:startTime];
    NSDate *endDdate = [date dateFromString:endTime];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:startDate toDate:endDdate options:0];
    // 天
    NSInteger day = [dateComponents day];
    // 小时
    NSInteger house = [dateComponents hour];
    // 分
    NSInteger minute = [dateComponents minute];
    // 秒
    NSInteger second = [dateComponents second];
    NSString *timeStr;
    if (day != 0) {
        timeStr = [NSString stringWithFormat:@"%zd天%zd小时%zd分%zd秒", day, house, minute, second];
    } else if (day == 0 && house != 0) {
        timeStr = [NSString stringWithFormat:@"%zd小时%zd分%zd秒", house, minute, second];
    } else if (day == 0 && house == 0 && minute != 0) {
        timeStr = [NSString stringWithFormat:@"%zd分%zd秒", minute, second];
    } else {
        timeStr = [NSString stringWithFormat:@"%zd秒", second];
    }
    
    return timeStr;
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
