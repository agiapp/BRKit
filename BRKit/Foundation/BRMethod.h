//
//  BRMethod.h
//  BRKitDemo
//
//  Created by 任波 on 2018/4/20.
//  Copyright © 2018年 91renb. All rights reserved.
//

#ifndef BRMethod_h
#define BRMethod_h

///==================================================
///            static inline 内联函数
///==================================================

//static inline UIEdgeInsets br_safeAreaInset(UIView *view) {
//    if (@available(iOS 11.0, *)) {
//        return view.safeAreaInsets;
//    }
//    return UIEdgeInsetsZero;
//}

//static inline MASConstraint * br_safeAreaBottom(MASConstraintMaker *make,UIView *view) {
//    if (@available(iOS 11.0, *)) {
//        //mas_safeAreaLayoutGuideBottom
//        return make.bottom.equalTo(view.mas_safeAreaLayoutGuideBottom);
//    }
//    return make.bottom.equalTo(view);
//}

static inline BOOL br_isZeroFloat(float f) {
    const float EPSINON = 0.0001;
    if ((f >= -EPSINON) && f <= EPSINON) {
        return YES;
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

/** 判断对象是否为空 */
static inline BOOL br_isEmpty(id thing) {
    return thing == nil ||
    [thing isEqual:[NSNull null]] ||
    [thing isEqual:@"null"] ||
    [thing isEqual:@"(null)"] ||
    ([thing respondsToSelector:@selector(length)]
     && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]
     && [(NSArray *)thing count] == 0);
}

/** 获取非空字符串，可指定缺省值 */
static inline NSString *br_nonullString(NSString *obj, NSString *msg) {
    if (obj == nil ||
        [obj isEqual:[NSNull null]] ||
        [obj isEqual:@"(null)"] ||
        [obj isEqual:@"null"] || obj.length == 0) {
        return msg;
    }
    return obj;
}

/** 获取非空number，可指定缺省值 */
static inline NSString *br_nonullNumber(NSNumber *obj, NSString *msg) {
    if (obj == nil ||
        [obj isEqual:[NSNull null]] ||
        [obj isEqual:@"(null)"] ||
        [obj isEqual:@"null"]) {
        return msg;
    }
    // 修复网络数据解析小数位精度丢失问题（建议：后台不要传浮点类型数字，直接传字符串）
    NSString *doubleString = [NSString stringWithFormat:@"%lf", obj.doubleValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

#pragma mark - 获取有效"年月日"日期字符串(2019-09-09)
static inline NSString *br_getDateYMDString(NSString *dateString) {
    if (!br_isEmpty(dateString) && dateString.length >= 10) {
        NSString *yearStr = [dateString substringToIndex:4];
        if ([yearStr integerValue] > 1900) {
            return [dateString substringToIndex:10];
        }
    }
    return @"－";
}

#endif /* BRMethod_h */
