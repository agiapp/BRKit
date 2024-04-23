//
//  NSDictionary+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/4/22.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import "NSDictionary+BRAdd.h"
#import "BRKitMacro.h"
#import "BRMethod.h"
#import "NSString+BRAdd.h"

BRSYNTH_DUMMY_CLASS(NSDictionary_BRAdd)

@implementation NSDictionary (BRAdd)

#pragma mark - 字典 转 json字符串（一整行输出，没有空格和换行符）
- (NSString *)br_toJsonStringNoFormat {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        // 1.转化为 JSON 格式的 NSData
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error) {
            NSLog(@"字典转JSON字符串失败：%@", error);
        }
        // 2.转化为 JSON 格式的 NSString
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - 字典 转 json字符串（格式化输出，有空格和换行符)
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

#pragma mark - 把排序后的字典拼成url字符串（根据key升序/降序排列）
// 提示：iOS中字典是无序的，所以不能返回字典
- (NSString *)br_toURLStringWithSortedDictionary:(BRDictionarySortType)type {
    NSArray *allKeyArr = [self allKeys];
    // 数组排序方法
    NSArray *sortAllKeyArr = [allKeyArr sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
    /*
        NSComparisonResult resuest = [obj1 compare:obj2]; 为从小到大,即升序;
        NSComparisonResult resuest = [obj2 compare:obj1]; 为从大到小,即降序;
        注意:compare方法是区分大小写的,即按照ASCII排序
    */
        // 先转化为小写字母，再比较（即忽略大小写的比较）
        obj1 = [obj1 lowercaseString];
        obj2 = [obj2 lowercaseString];
        // 排序操作
        if (type == BRDictionarySortTypeAsc) {
            return [obj1 compare:obj2 options:NSNumericSearch]; // 升序排列
        } else {
            return [obj2 compare:obj1 options:NSNumericSearch]; // 降序排列
        }
    }];
    // 通过排列的key值获取value
    NSMutableString *mutableStr = [NSMutableString string];
    for (NSString *key in sortAllKeyArr) {
        NSString *obj = [self objectForKey:key];
        [mutableStr appendFormat:@"%@=%@&", key, obj];
    }
    if ([mutableStr rangeOfString:@"&"].length) {
        [mutableStr deleteCharactersInRange:NSMakeRange(mutableStr.length - 1, 1)];
    }
    
    return mutableStr;
}

#pragma mark - 把字典拼成url字符串
- (NSString *)br_toURLString {
    NSMutableString *mutableStr = [NSMutableString string];
    // 遍历字典把键值拼起来
    [self enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        [mutableStr appendFormat:@"%@=%@&",key, obj];
    }];
    if ([mutableStr rangeOfString:@"&"].length) {
        [mutableStr deleteCharactersInRange:NSMakeRange(mutableStr.length - 1, 1)];
    }
    return mutableStr;
}

@end


@implementation NSMutableDictionary (BRAdd)

#pragma mark - 给可变字典添加键值对
- (void)br_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (br_isEmptyObject(aKey)) {
        return;
    }
    if (br_isEmptyObject(anObject) && ![anObject isEqual:@""]) {
        return;
    }
    [self setObject:anObject forKey:aKey];
}

@end
