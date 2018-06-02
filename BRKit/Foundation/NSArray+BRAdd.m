//
//  NSArray+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/4/21.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSArray+BRAdd.h"
#import "BRKitMacro.h"
#import "BRMethod.h"

BRSYNTH_DUMMY_CLASS(NSArray_BRAdd)

@implementation NSArray (BRAdd)

#pragma mark - 数组 转 json字符串
- (NSString *)br_toJsonString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        // 1.转化为 JSON 格式的 NSData
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"数组转JSON字符串失败：%@", error);
        }
        // 2.转化为 JSON 格式的 NSString
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - 数组倒序
- (NSArray *)br_reverse {
    return [[self reverseObjectEnumerator] allObjects];
}

@end

@implementation NSMutableArray (BRAdd)
#pragma mark - 添加元素
- (void)br_addObject:(id)anObject {
    if (br_isEmpty(anObject)) {
        return;
    }
    [self addObject:anObject];
}

@end
