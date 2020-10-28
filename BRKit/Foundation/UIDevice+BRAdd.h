//
//  UIDevice+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/6/4.
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

/// IP地址（如：192.168.1.10）
- (NSString *)br_ipAddresses;

@end
