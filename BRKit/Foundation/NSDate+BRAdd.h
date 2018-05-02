//
//  NSDate+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
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
 *  返回指定时间差值的日期字符串
 *
 *  @param delta 时间差值
 *  @return 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 */
+ (nullable NSString *)br_dateStringWithDelta:(NSTimeInterval)delta;

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
