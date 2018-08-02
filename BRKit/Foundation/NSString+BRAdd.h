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

/** md5加密（32位小写） */
- (nullable NSString *)br_md5String;

/** md5加密（16位小写） */
- (nullable NSString *)br_md5String16;

/** sha1加密（小写） */
- (NSString *)br_sha1String;

/**
 *  返回一个新的UUID字符串（随机字符串，每次获取都不一样）
 *  如："3FE15217-D71E-4B4F-9919-B388A8D13914"
 */
+ (NSString *)br_UUID;

/** 转UTF8字符串（UTF-8编码）*/
- (NSString *)br_utf8String;

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

/** label富文本: 插入图片 */
- (NSMutableAttributedString *)br_setRichTextWithImage:(NSString *)iconName bounds:(CGRect)bounds iconLocation:(NSInteger)location;

/** label富文本: 设置不同字体和颜色 */
- (NSMutableAttributedString *)br_setChangeText:(NSString *)changeText changeFont:(nullable UIFont *)font changeTextColor:(nullable UIColor *)color;

/** label富文本: HTML标签文本 */
- (NSMutableAttributedString *)br_setTextHTMLString;

/** label富文本: 添加中划线 */
- (NSMutableAttributedString *)br_setTextLineThrough;

/** 设置文本关键词红色显示 */
// <em>苹果</em><em>科技</em>股份有限公司
- (NSAttributedString *)br_setTextKeywords:(UIColor *)keywordColor;

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
