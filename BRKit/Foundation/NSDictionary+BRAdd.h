//
//  NSDictionary+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/4/22.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (BRAdd)
/** 字典 转 json字符串 */
- (nullable NSString *)br_toJsonString;
/** 把字典拼成url字符串 */
- (nullable NSString *)br_toURLString;

@end

@interface NSMutableDictionary (BRAdd)
/** 给可变字典添加键值对 */
- (void)br_setObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
