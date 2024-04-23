//
//  BRMethod.h
//  BRKitDemo
//
//  Created by renbo on 2018/4/20.
//  Copyright © 2018年 irenb. All rights reserved.
//

#ifndef BRMethod_h
#define BRMethod_h

///==================================================
///            static inline 内联函数
///==================================================

/**
 *  判断对象是否为null
 *  @return nil、NSNil、@"null"、@"(null)" 返回 YES，其它返回为 NO
 */
static inline BOOL br_isNullOrNil(id object) {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    }
    if ([object isEqual:@"null"] || [object isEqual:@"NULL"] || [object isEqual:@"(null)"]) {
        return YES;
    }
    return NO;
}

/**
 *  判断对象是否不为null
 */
static inline BOOL br_isNotNullOrNil(id object) {
    return !br_isNullOrNil(object);
}

/**
 *  判断对象是否为空
 *  nil、NSNil、@"null"、@"(null)"、@""、@[]、@{} 返回 YES
 *  @return YES 为空，NO 为实例对象
 */
static inline BOOL br_isEmptyObject(id object) {
    if (br_isNullOrNil(object)) {
        return YES;
    }
    if ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) {
        return YES;
    }
    if ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0) {
        return YES;
    }
    return NO;
}

/**
 *  判断对象是否不为空
 */
static inline BOOL br_isNotEmptyObject(id object) {
    return !br_isEmptyObject(object);
}

/**
 *  判断是否是有效的(非空/非空白)字符串
 *  @return @"(null)", @"null", nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
static inline BOOL br_isValidString(NSString *object) {
    if (br_isEmptyObject(object)) {
        return NO;
    }
    if (![object isKindOfClass:[NSString class]]) {
        return NO;
    }
    // 修剪字符串（去掉头尾两边的空格和换行符）
    NSString *string = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length] == 0) {
        return NO;
    }
    
    return YES;
}

/**
 *  判断是否是正数（即值是大于零的 NSString 或 NSNumber 类型的数字）
 *  nil、NSNil、@0、@-1、@""、@"0"、@"-1" 返回 NO
 *  @return YES 为有效ID, NO 为无效
 */
static inline BOOL br_isValidPositiveNumber(id object) {
    if (br_isEmptyObject(object)) {
        return NO;
    }
    NSString *numberString = [NSString stringWithFormat:@"%@", object];
    // 修剪字符串（去掉头尾两边的空格和换行符）
    numberString = [numberString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([numberString length] == 0 || [numberString doubleValue] <= 0) {
        return NO;
    }
    
    return YES;
}

/** 获取非空字符串，可指定缺省值 */
static inline NSString *br_nonullString(NSString *object, NSString *placeholder) {
    if (br_isValidString(object)) {
        return object;
    }
    return placeholder ? placeholder : @"--";
}

/** 获取非空number，可指定缺省值 */
static inline NSString *br_nonullNumber(NSNumber *object, NSString *placeholder) {
    if (br_isNullOrNil(object) || [object isEqualToNumber:@0] || [object isEqualToNumber:@(-1)]) {
        return placeholder ? placeholder : @"--";
    }
    // 修复网络数据解析小数位精度丢失问题（建议：后台不要传浮点类型数字，直接传字符串）
    NSString *doubleString = [NSString stringWithFormat:@"%lf", object.doubleValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

/** 获取有效"年月日"日期字符串(2019-09-09) */
static inline NSString *br_getDateYMDString(NSString *dateString, NSString *placeholder) {
    if (br_isValidString(dateString)) {
        if ([dateString containsString:@"*"]) {
            return dateString;
        }
        if (dateString.length >= 10) {
            NSString *yearStr = [dateString substringToIndex:4];
            if ([yearStr integerValue] > 1900) {
                return [dateString substringToIndex:10];
            }
        }
    }
    return placeholder ? placeholder : @"--";
}

/** 判断是否是有效日期字符串(年份大于1900) */
static inline BOOL br_isValidDateString(NSString *dateString) {
    if (br_isValidString(dateString) && dateString.length >= 4 && ![dateString containsString:@"*"]) {
        NSString *yearStr = [dateString substringToIndex:4];
        if ([yearStr integerValue] > 1900) {
            return YES;
        }
    }
    return NO;
}

/** 获取字符串（对象转字符串）*/
static inline NSString *br_stringFromObject(id object) {
    if (br_isNullOrNil(object)) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object respondsToSelector:@selector(stringValue)]) {
        return [object stringValue];
    } else {
        return [object description];
    }
}

/** 处理有效参数（有效字符串） */
static inline NSString *br_filterValidString(NSString *string) {
    if (br_isValidString(string)) {
        return string;
    }
    return nil;
}

/** 处理有效参数（参数ID，数值大于0）*/
static inline id br_filterValidID(id object) {
    if (br_isValidPositiveNumber(object)) {
        return object;
    }
    return nil;
}

#endif /* BRMethod_h */
