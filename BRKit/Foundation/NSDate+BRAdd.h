//
//  NSDate+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BRAdd)

/** 获取系统当前的时间戳，即当前时间距1970的秒数（以毫秒为单位） */
+ (NSString *)br_timestamp;

/** 获取当前的时间 */
+ (NSString *)br_currentDateString;

/**
 *  按指定格式获取当前的时间
 *
 *  @param  formatterStr  设置格式：yyyy-MM-dd HH:mm:ss
 */
+ (nullable NSString *)br_currentDateStringWithFormat:(NSString *)formatterStr;

/**
 *  按指定格式返回时间字符串
 *
 *  @param  dateString  日期字符串
 *  @param  oldFormat   旧格式
 *  @param  newFormat   新格式
 */
+ (nullable NSString *)br_dateString:(NSString *)dateString oldFormat:(NSString *)oldFormat newFormat:(NSString *)newFormat;

/** 日期和字符串之间的转换：NSDate --> NSString */
+ (nullable  NSString *)br_getDateString:(NSDate *)date format:(NSString *)format;

/** 日期和字符串之间的转换：NSString --> NSDate */
+ (nullable  NSDate *)br_getDate:(NSString *)dateString format:(NSString *)format;

/**
 *  返回指定时间差值的日期字符串
 *
 *  @param delta 时间差值
 *  @return 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 */
+ (nullable NSString *)br_dateStringWithDelta:(NSTimeInterval)delta;

/**
 *  计算任意2个时间之间的间隔(单位：秒)
 *
 *  @param starTime 开始时间
 *  @param endTime  结束时间
 *  @return 时间差，秒数
 */
+ (NSTimeInterval)br_timeIntervalWithStarTime:(NSString *)starTime endTime:(NSString *)endTime;

/**
 * @method
 *
 * @brief 获取两个日期之间的天数
 * @param fromDate       起始日期
 * @param toDate         终止日期
 * @return    总天数
 */
+ (NSInteger)br_numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 计算两个时间相差多少天多少小时多少分多少秒
 
 @param startTime 开始时间
 @param endTime 结束时间
 @return 时间差
 */
- (nullable NSString *)br_dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 *  返回日期格式字符串
 *
 *  @param dateStr 需要转换的时间点
 *  @return 日期字符串
 *    返回具体格式如下：
 *      - 刚刚(一分钟内)
 *      - X分钟前(一小时内)
 *      - X小时前(当天)
 *      - MM-dd HH:mm(一年内)
 *      - yyyy-MM-dd HH:mm(更早期)
 */
+ (nullable NSString *)br_dateDescriptionWithTargetDate:(NSString *)dateStr andTargetDateFormat:(NSString *)dateFormatStr;

@end

NS_ASSUME_NONNULL_END
