//
//  NSDictionary+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/4/22.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSDictionary+BRAdd.h"

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

@end
