//
//  BRKitMacro.h
//  BRKitDemo
//
//  Created by 任波 on 2018/4/20.
//  Copyright © 2018年 91renb. All rights reserved.
//

#ifndef BRKitMacro_h
#define BRKitMacro_h

/**
 合成弱引用/强引用
 
 Example:
     @weakify(self)
     [self doSomething^{
         @strongify(self)
         if (!self) return;
         ...
     }];
 
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

/** 常用的断言 */
#define BRAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define BRCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define BRAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define BRCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define BRAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define BRCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")

/**
    静态库中编写 Category 时的便利宏，用于解决 Category 方法从静态库中加载需要特别设置的问题。
    加入这个宏后，不需要再在 Xcode 的 Other Liker Fliags 中设置链接库参数（-Objc / -all_load / -force_load）
    *******************************************************************************
    使用:在静态库中每个分类的 @implementation 前添加这个宏
    Example:
        #import "NSString+BRAdd.h"
 
        BRSYNTH_DUMMY_CLASS(NSString_BRAdd)
        @implementation NSString (BRAdd)
        @end
 */
#ifndef BRSYNTH_DUMMY_CLASS

    #define BRSYNTH_DUMMY_CLASS(_name_) \
    @interface BRSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
    @implementation BRSYNTH_DUMMY_CLASS_ ## _name_ @end

#endif

/** 交换两个数值 */
#ifndef BR_SWAP
#define BR_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

#endif /* BRKitMacro_h */
