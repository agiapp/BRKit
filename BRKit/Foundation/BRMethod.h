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

/** 获取非空字符串 */
static inline NSString *br_nonullString(NSString *obj) {
    if (obj == nil ||
        [obj isEqual:[NSNull null]] ||
        [obj isEqual:@"(null)"] ||
        [obj isEqual:@"null"]) {
        return @"";
    }
    return obj;
}

#endif /* BRMethod_h */
