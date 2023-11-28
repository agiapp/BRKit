//
//  BRKitMacro.h
//  BRKitDemo
//
//  Created by renbo on 2018/4/20.
//  Copyright © 2018年 91renb. All rights reserved.
//

#ifndef BRKitMacro_h
#define BRKitMacro_h

/**
 ========== 合成弱引用/强引用 ==========
 
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

// 弱引用
#ifndef WEAKSELF
#define WEAKSELF __weak typeof(self) weakSelf = self;
#endif

/**
 ========== 常用的断言 ==========
 */
#define BRAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define BRCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define BRAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define BRCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define BRAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define BRCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")

/**
 ========== 静态库中编写 Category 时的便利宏 ==========
    静态库中编写 Category 时的便利宏，用于解决 Category 方法从静态库中加载需要特别设置的问题。
    加入这个宏后，不需要再在 Xcode 的 Other Liker Fliags 中设置链接库参数（-Objc / -all_load / -force_load）
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

/**
 ========== 交换两个数值 ==========
 */
#ifndef BR_SWAP
#define BR_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif


/**
 ========== 封装单例工具类：把创建单例的操作抽象成宏 ==========
    
 Example:
     // .h文件
     @interface MyCustomClass : NSObject
     singleton_interface(MyCustomClass)
     @end
     
     // .m文件
     @implementation MyCustomClass
     singleton_implementation(MyCustomClass)
     @end
     
     // 单例对象
     [MyCustomClass sharedMyCustomClass]
 */

// .h文件
#ifndef singleton_interface
#define singleton_interface(class) \
+ (instancetype)shared##class;

#endif

// .m文件
#ifndef singleton_implementation
#define singleton_implementation(class) \
static id _instance; \
+ (id)allocWithZone:(struct _NSZone *)zone { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
\
+ (instancetype)shared##class { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}

#endif


/**
 ========== 模型Copy：runtime实现通用copy ==========
 使用：
     1.模型遵循 NSCopying 协议
     2.在模型的 @implementation...@end 之间直接加一句 BR_CopyWithZone 这个宏
 */
#define BR_CopyWithZone \
- (id)copyWithZone:(NSZone *)zone {\
    id obj = [[[self class] allocWithZone:zone] init];\
    Class class = [self class];\
    while (class != [NSObject class]) {\
        unsigned int count;\
        Ivar *ivar = class_copyIvarList(class, &count);\
        for (int i = 0; i < count; i++) {\
            Ivar iv = ivar[i];\
            const char *name = ivar_getName(iv);\
            NSString *strName = [NSString stringWithUTF8String:name];\
            id value = [[self valueForKey:strName] copy];\
            [obj setValue:value forKey:strName];\
        }\
        free(ivar);\
        class = class_getSuperclass(class);\
    }\
    return obj;\
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone {\
    id obj = [[[self class] allocWithZone:zone] init];\
    Class class = [self class];\
    while (class != [NSObject class]) {\
        unsigned int count;\
        Ivar *ivar = class_copyIvarList(class, &count);\
        for (int i = 0; i < count; i++) {\
            Ivar iv = ivar[i];\
            const char *name = ivar_getName(iv);\
            NSString *strName = [NSString stringWithUTF8String:name];\
            id value = [[self valueForKey:strName] copy];\
            [obj setValue:value forKey:strName];\
        }\
        free(ivar);\
        class = class_getSuperclass(class);\
    }\
    return obj;\
}


/**
 ========== 模型归档/解档：runtime实现通用归档 ==========
 使用：
    1.模型遵循 NSCoding 和 NSSecureCoding 协议
    2.在模型的 @implementation...@end 之间直接加一句 BR_CodingImplementation 这个宏
    不管模型有多少个属性，只需要加一句宏 BR_CodingImplementation，就能实现归档解档，不用再编写 encodeWithCoder: 和 initWithCoder: 代码
 */
// 归档/解档（序列化/反序列化）
#define BR_CodingImplementation \
- (void)encodeWithCoder:(NSCoder *)aCoder { \
    unsigned int outCount = 0; \
    Ivar * vars = class_copyIvarList([self class], &outCount); \
    for (int i = 0; i < outCount; i++) { \
        Ivar var = vars[i]; \
        const char * name = ivar_getName(var); \
        NSString * key = [NSString stringWithUTF8String:name]; \
        id value = [self valueForKey:key]; \
        if (value) { \
            [aCoder encodeObject:value forKey:key]; \
        } \
    } \
} \
\
- (instancetype)initWithCoder:(NSCoder *)aDecoder { \
    if (self = [super init]) { \
        unsigned int outCount = 0; \
        Ivar * vars = class_copyIvarList([self class], &outCount); \
        for (int i = 0; i < outCount; i++) { \
            Ivar var = vars[i]; \
            const char * name = ivar_getName(var); \
            NSString * key = [NSString stringWithUTF8String:name]; \
            id value = [aDecoder decodeObjectForKey:key]; \
            if (value) { \
                [self setValue:value forKey:key]; \
            } \
        } \
    } \
    return self; \
}

// 归档/解档的实现：支持加密编码
#define BR_SecureCodingImplementation(CLASS, FLAG) \
@interface CLASS (BRSecureCoding) <NSSecureCoding> \
@end \
@implementation CLASS (BRSecureCoding) \
BR_CodingImplementation \
+ (BOOL)supportsSecureCoding { \
    return FLAG; \
}


#endif /* BRKitMacro_h */
