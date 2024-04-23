//
//  NSArray+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/4/21.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (BRAdd)
/** 字典 转 json字符串（一整行输出，没有空格和换行符）*/
- (nullable NSString *)br_toJsonStringNoFormat;
/** 数组/字典 转 json字符串 */
- (nullable NSString *)br_toJsonString;
/** 数组倒序 */
- (NSArray *)br_reverse;

@end

@interface NSMutableArray (BRAdd)
/** 添加元素 */
- (void)br_addObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
