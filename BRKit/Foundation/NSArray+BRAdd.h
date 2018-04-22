//
//  NSArray+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/4/21.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (BRAdd)
/** 数组/字典 转 json字符串 */
- (nullable NSString *)br_toJsonString;
/** 倒序数组 */
- (NSArray *)br_reverseArray;

@end

@interface NSMutableArray (BRAdd)
/** 倒序数组 */
- (void)br_reverseMutableArray;

@end

NS_ASSUME_NONNULL_END
