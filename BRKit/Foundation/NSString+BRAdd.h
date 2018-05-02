//
//  NSString+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/4/19.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BRAdd)

/** 判断是否是有效的(非空/非空白)字符串 */
- (BOOL)br_isValidString;

/** 判断是否包含指定字符串 */
- (BOOL)br_containsString:(NSString *)string;

/* 修剪字符串（去掉头尾两边的空格和换行符）*/
- (NSString *)br_stringByTrim;

/** md5加密 */
- (nullable NSString *)br_md5String;

/**
 *  获取文本的大小
 *
 *  @param  font           文本字体
 *  @param  maxSize        文本区域的最大范围大小
 *  @param  lineBreakMode  字符截断类型
 *
 *  @return 文本大小
 */
- (CGSize)br_getTextSize:(UIFont *)font maxSize:(CGSize)maxSize mode:(NSLineBreakMode)lineBreakMode;

/**
 *  获取文本的宽度
 *
 *  @param  font    文本字体
 *  @param  height  文本高度
 *
 *  @return 文本宽度
 */
- (CGFloat)br_getTextWidth:(UIFont *)font height:(CGFloat)height;

/**
 *  获取文本的高度
 *
 *  @param  font   文本字体
 *  @param  width  文本宽度
 *
 *  @return 文本高度
 */
- (CGFloat)br_getTextHeight:(UIFont *)font width:(CGFloat)width;


///==================================================
///             正则表达式
///==================================================
/** 判断是否是有效的手机号 */
- (BOOL)br_isValidPhoneNumber;

/** 判断是否是有效的用户密码 */
- (BOOL)br_isValidPassword;

/** 判断是否是有效的用户名（20位的中文或英文）*/
- (BOOL)br_isValidUserName;

/** 判断是否是有效的邮箱 */
- (BOOL)br_isValidEmail;

/** 判断是否是有效的URL */
- (BOOL)isValidUrl;

/** 判断是否是有效的银行卡号 */
- (BOOL)br_isValidBankNumber;

/** 判断是否是有效的身份证号 */
- (BOOL)br_isValidIDCardNumber;

/** 判断是否是有效的IP地址 */
- (BOOL)br_isValidIPAddress;

/** 判断是否是纯汉字 */
- (BOOL)br_isValidChinese;

/** 判断是否是邮政编码 */
- (BOOL)br_isValidPostalcode;

/** 判断是否是工商税号 */
- (BOOL)br_isValidTaxNo;

/** 判断是否是车牌号 */
- (BOOL)br_isCarNumber;

/** 通过身份证获取性别（1:男, 2:女） */
- (nullable NSNumber *)br_getGenderFromIDCard;

/** 隐藏证件号指定位数字（如：360723********6341） */
- (nullable NSString *)br_hideCharacters:(NSUInteger)location length:(NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
