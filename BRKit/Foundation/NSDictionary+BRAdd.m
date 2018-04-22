//
//  NSDictionary+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/4/22.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSDictionary+BRAdd.h"
#import "BRKitMacro.h"
#import "BRMethod.h"

BRSYNTH_DUMMY_CLASS(NSDictionary_BRAdd)

@implementation NSDictionary (BRAdd)

#pragma mark - 字典 转 json字符串
- (NSString *)br_toJsonString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        // 1.转化为 JSON 格式的 NSData
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"字典转JSON字符串失败：%@", error);
        }
        // 2.转化为 JSON 格式的 NSString
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - 把字典拼成url字符串
- (NSString *)br_toURLString {
    NSMutableString *mutableStr = [NSMutableString string];
    // 遍历字典把键值拼起来
    [self enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        [mutableStr appendFormat:@"%@=", key];
        [mutableStr appendFormat:@"%@", obj];
        [mutableStr appendFormat:@"%@", @"&"];
    }];
    NSString *result = [mutableStr copy];
    // 去掉最后一个&
    if ([result hasSuffix:@"&"]) {
        result = [result substringToIndex:result.length - 2];
    }
    return result;
}

@end


@implementation NSMutableDictionary (BRAdd)

#pragma mark - 给可变字典添加键值对
- (void)br_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (br_isEmpty(aKey)) {
        return;
    }
    if (br_isEmpty(anObject) && ![anObject isEqual:@""]) {
        return;
    }
    [self setObject:anObject forKey:aKey];
}

@end
