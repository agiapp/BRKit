//
//  UIDevice+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (BRAdd)

/// 顶部安全区高度
+ (CGFloat)br_safeDistanceTop;

/// 底部安全区高度
+ (CGFloat)br_safeDistanceBottom;

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)br_statusBarHeight;

/// 导航栏高度
+ (CGFloat)br_navigationBarHeight;

/// 状态栏+导航栏的高度
+ (CGFloat)br_navigationFullHeight;

/// 底部导航栏高度
+ (CGFloat)br_tabBarHeight;

/// 底部导航栏高度（包括安全区）
+ (CGFloat)br_tabBarFullHeight;


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

/// 获取广告唯一标识（如：6B35AE34-A952-40BF-A015-39D195362CE1）
//- (void)br_getIDFAString:(void (^)(NSString *idfaString))successBlock failureBlock:(void (^)(void))failureBlock;

@end
