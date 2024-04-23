//
//  UIColor+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef UIColorHex
#define UIColorHex(_hex_) [UIColor br_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

@interface UIColor (BRAdd)

/**
 *  创建颜色对象
 *
 *  @param rgbValue  16进制的RGB值（如：0x66ccff）
 *
 *  @return 颜色对象
 */
+ (UIColor *)br_colorWithRGB:(uint32_t)rgbValue;

/**
 *  创建颜色对象
 *
 *  @param rgbValue  16进制的RGB值（如：0x66ccff）
 *  @param alpha     不透明度值（值范围：0.0 ~ 1.0）
 *
 *  @return 颜色对象
 */
+ (UIColor *)br_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
 *  创建颜色对象
 *  
 *  @param hexStr  颜色的16进制字符串值（格式如：@"#66ccff", @"#6cf", @"#66ccff88", @"#6cf8", @"0x66ccff", @"66ccff"...）
 *
 *  @return 颜色对象
 */
+ (nullable UIColor *)br_colorWithHexString:(NSString *)hexStr;

/**
 *  @brief  渐变颜色
 *
 *  @param fromColor  开始颜色
 *  @param toColor    结束颜色
 *  @param height     渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)br_gradientFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor withHeight:(CGFloat)height;



//================================================= 动态颜色 =================================================

/**
 *  系统背景颜色1：systemBackgroundColor
 */
+ (UIColor *)br_systemBackgroundColor;

/**
 *  系统背景颜色2：secondarySystemBackgroundColor
 */
+ (UIColor *)br_secondarySystemBackgroundColor;

/**
 *  系统背景颜色3：tertiarySystemBackgroundColor
 */
+ (UIColor *)br_tertiarySystemBackgroundColor;

/**
 *  Grouped 背景颜色1（如，UITableView 背景颜色）：systemGroupedBackgroundColor
 */
+ (UIColor *)br_systemGroupedBackgroundColor;

/**
 *  Grouped 背景颜色2（如，UITableViewCell 背景颜色）：secondarySystemGroupedBackgroundColor
 */
+ (UIColor *)br_secondarySystemGroupedBackgroundColor;

/**
 *  Grouped 背景颜色3：tertiarySystemGroupedBackgroundColor
 */
+ (UIColor *)br_tertiarySystemGroupedBackgroundColor;

/**
 *  边框线背景颜色（有透明度）：separatorColor
 */
+ (UIColor *)br_separatorColor;

/**
 *  分隔线背景颜色（无透明度）：opaqueSeparatorColor
 */
+ (UIColor *)br_opaqueSeparatorColor;

/**
 *  文本颜色1：labelColor
 */
+ (UIColor *)br_labelColor;

/**
 *  文本颜色2：secondaryLabelColor
 */
+ (UIColor *)br_secondaryLabelColor;

/**
 *  文本颜色3：tertiaryLabelColor
 */
+ (UIColor *)br_tertiaryLabelColor;

/**
 *  超链接文本颜色：linkColor
 */
+ (UIColor *)br_linkColor;

/**
 *  占位文本颜色：placeholderTextColor（等于 tertiaryLabelColor）
 */
+ (UIColor *)br_placeholderTextColor;

/**
*  创建自定义动态颜色（适配深色模式）
*
*  @param lightColor  正常模式颜色
*  @param darkColor   深色模式颜色
*
*  @return 颜色对象
*/
+ (UIColor *)br_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;


@end

NS_ASSUME_NONNULL_END
