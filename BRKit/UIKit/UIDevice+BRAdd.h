//
//  UIDevice+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/5/17.
//  Copyright © 2018年 91renb. All rights reserved.
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
