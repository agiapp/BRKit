//
//  BRMethod.h
//  BRKitDemo
//
//  Created by renbo on 2018/4/20.
//  Copyright © 2018年 91renb. All rights reserved.
//

#ifndef BRMethod_h
#define BRMethod_h

///==================================================
///            static inline 内联函数
///==================================================

/** 判断对象是否为空 */
static inline BOOL br_isEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]] ||
    [thing isEqual:@"null"] || [thing isEqual:@"(null)"] ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0);
}

/**
 *  判断对象是否为null
 *  nil、NSNil、@"null"、@"(null)" 返回 NO
 *  @return YES 为实例对象, NO 为空
 */
static inline BOOL br_isNotNullOrNil(id object) {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return NO;
    }
    if ([object isEqual:@"null"] || [object isEqual:@"(null)"]) {
        return NO;
    }
    return YES;
}

/**
 *  判断对象是否为空
 *  nil、NSNil、@"null"、@"(null)"、@""、@0、@[]、@{} 返回 NO
 *  @return YES 为实例对象, NO 为空
 */
static inline BOOL br_isNotEmptyObject(id object) {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return NO;
    }
    if ([object isEqual:@"null"] || [object isEqual:@"(null)"] || [object isEqual:@""]) {
        return NO;
    }
    if ([object isKindOfClass:[NSNumber class]] && [object isEqualToNumber:@0]) {
        return NO;
    }
    if ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) {
        return NO;
    }
    if ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0) {
        return NO;
    }
    return YES;
}

/**
 *  判断是否是有效的参数数字（即值是大于零的 NSString 或 NSNumber 类型的数字）
 *  nil、NSNil、@0、@-1、@""、@"0"、@"-1" 返回 NO
 *  @return YES 为有效ID, NO 为无效
 */
static inline BOOL br_isValidParamNumber(id object) {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return NO;
    }
    if ([object isEqual:@"null"] || [object isEqual:@"(null)"] || [object isEqual:@""]) {
        return NO;
    }
    NSString *IDString = [NSString stringWithFormat:@"%@", object];
    // 修剪字符串（去掉头尾两边的空格和换行符）
    IDString = [IDString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([IDString length] == 0 || [IDString doubleValue] <= 0) {
        return NO;
    }
    
    return YES;
}

/** 获取非空字符串，可指定缺省值 */
static inline NSString *br_nonullString(NSString *obj, NSString *placeholder) {
    if (obj == nil || [obj isEqual:[NSNull null]] ||
        [obj isEqual:@"(null)"] || [obj isEqual:@"null"] || obj.length == 0) {
        return placeholder ? placeholder : @"--";
    }
    return obj;
}

/** 获取非空number，可指定缺省值 */
static inline NSString *br_nonullNumber(NSNumber *obj, NSString *placeholder) {
    if (obj == nil || [obj isEqual:[NSNull null]] || [obj isEqualToNumber:@0] || [obj isEqualToNumber:@(-1)]) {
        return placeholder ? placeholder : @"--";
    }
    // 修复网络数据解析小数位精度丢失问题（建议：后台不要传浮点类型数字，直接传字符串）
    NSString *doubleString = [NSString stringWithFormat:@"%lf", obj.doubleValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

/** 获取有效"年月日"日期字符串(2019-09-09) */
static inline NSString *br_getDateYMDString(NSString *dateString, NSString *placeholder) {
    if (!br_isEmpty(dateString)) {
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
    if (!br_isEmpty(dateString) && dateString.length >= 4 && ![dateString containsString:@"*"]) {
        NSString *yearStr = [dateString substringToIndex:4];
        if ([yearStr integerValue] > 1900) {
            return YES;
        }
    }
    return NO;
}

/** 获取字符串（对象转字符串）*/
static inline NSString *br_stringFromObject(id object) {
    if (object == nil ||
        [object isEqual:[NSNull null]] ||
        [object isEqual:@"(null)"] ||
        [object isEqual:@"null"]) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object respondsToSelector:@selector(stringValue)]){
        return [object stringValue];
    } else {
        return [object description];
    }
}

#endif /* BRMethod_h */
