//
//  UIDevice+BRAdd.h
//  BRKit
//
//  Created by 筑龙股份 on 2018/6/4.
//

#import <UIKit/UIKit.h>

@interface UIDevice (BRAdd)
// 获取设备IP地址
+ (NSString *)localIPAddress;

/** 获取ip */
+ (NSString *)getDeviceIPAddresses;

+ (NSString *)getIpAddressWIFI;
+ (NSString *)getIpAddressCell;

@end
