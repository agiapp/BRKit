//
//  UIDevice+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (BRAdd)

/// 系统（如：iOS 13.5.1）
- (NSString *)br_systemString;

/// 设备型号标记(如：iPhone8,1)
- (NSString *)br_platform;

/// 设备型号(如：iPhone 6s)
- (NSString *)br_platformString;

/// MAC地址（如：02:C9:56:41:00:00）
- (NSString *)br_macAddress;

/** 获取设备内网IP（局域网IP，如：192.168.1.10）只能获取到WiFi环境下的本地IP */
- (NSString *)br_deviceIPAddress;
/** 获取设备外网IP（公网IP） */
- (NSString *)br_WANIPAddress;

/// 获取广告唯一标识
- (NSString *)br_getIDFAString;

@end
