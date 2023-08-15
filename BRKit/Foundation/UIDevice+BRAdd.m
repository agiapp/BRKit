//
//  UIDevice+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UIDevice+BRAdd.h"
#include <sys/sysctl.h>
#include <net/if_dl.h>
#import <sys/utsname.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

//// 广告标识符头文件
//#import <AdSupport/ASIdentifierManager.h>
//#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation UIDevice (BRAdd)

/// 顶部安全区高度
+ (CGFloat)br_safeDistanceTop {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 底部安全区高度
+ (CGFloat)br_safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}


/// 顶部状态栏高度（包括安全区）
+ (CGFloat)br_statusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

/// 导航栏高度
+ (CGFloat)br_navigationBarHeight {
    return 44.0f;
}

/// 状态栏+导航栏的高度
+ (CGFloat)br_navigationFullHeight {
    return [UIDevice br_safeDistanceTop] + [UIDevice br_navigationBarHeight];
}

/// 底部导航栏高度
+ (CGFloat)br_tabBarHeight {
    return 49.0f;
}

/// 底部导航栏高度（包括安全区）
+ (CGFloat)br_tabBarFullHeight {
    return [UIDevice br_statusBarHeight] + [UIDevice br_safeDistanceBottom];
}


#pragma mark - 设备搭载系统及版本号
- (NSString *)br_systemString {
    return [NSString stringWithFormat:@"%@ %@", self.systemName, self.systemVersion];
}

#pragma mark - 设备型号标记
- (NSString *)br_platform {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    return deviceString;
}

#pragma mark - 将Model Identifier转为设备型号
- (NSString *)br_platformString {
    NSString *platform = [self br_platform];
    // 适配：intel和M系列Mac芯片
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"] || [platform isEqualToString:@"arm64"]) {
        return @"Simulator"; //注意：请使用真机测试，使用模拟器会返回Simulator（与模拟器所对应的机型无关）
    }
    if([platform hasPrefix:@"iPhone"]) {
        return iPhonePlatform(platform);
    }
    if([platform hasPrefix:@"iPad"]) {
        return iPadPlatform(platform);
    }
    if([platform hasPrefix:@"iPod"]) {
        return iPodPlatform(platform);
    }
    if([platform hasPrefix:@"AirPods"] || [platform hasPrefix:@"iProd"] || [platform hasPrefix:@"Audio"]) {
        return AirPodsPlatform(platform);
    }
    if([platform hasPrefix:@"AppleTV"]) {
        return AppleTVPlatform(platform);
    }
    if([platform hasPrefix:@"Watch"]) {
        return AppleWatchPlatform(platform);
    }
    if([platform hasPrefix:@"AudioAccessory"]) {
        return HomePodPlatform(platform);
    }
    if([platform hasPrefix:@"AirTag"]) {
        return AirTagPlatform(platform);
    }
    
    NSLog(@"Unknown Device: %@", platform);
    
    return platform;
}

#pragma mark - iPhone
NSString *iPhonePlatform(NSString *platform) {
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone";
    //2008年6月发布，更新一种机型：iPhone 3G
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    //2009年6月发布，更新一种机型：iPhone 3G
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    //2010年6月发布，更新一种机型：iPhone 4
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    //2011年10月发布，更新一种机型：iPhone 4s
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4s";
    //2012年9月发布，更新一种机型：iPhone 5
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    //2013年9月发布，更新二种机型：iPhone 5c、iPhone 5s
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    //2014年9月发布，更新二种机型：iPhone 6、iPhone 6 Plus
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    //2015年9月发布，更新二种机型：iPhone 6s、iPhone 6s Plus
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    //2016年3月发布，更新一种机型：iPhone SE
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    //2016年9月发布，更新二种机型：iPhone 7、iPhone 7 Plus
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    //2017年9月发布，更新三种机型：iPhone 8、iPhone 8 Plus、iPhone X
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    //2018年10月发布，更新三种机型：iPhone XR、iPhone XS、iPhone XS Max
    if ([platform isEqualToString:@"iPhone11,8"])   return  @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    //2019年9月发布，更新三种机型：iPhone 11、iPhone 11 Pro、iPhone 11 Pro Max
    if ([platform isEqualToString:@"iPhone12,1"])   return  @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])   return  @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])   return  @"iPhone 11 Pro Max";
    //2020年4月发布，更新一种机型：iPhone SE2
    if ([platform isEqualToString:@"iPhone12,8"])   return  @"iPhone SE 2";
    //2020年10月发布，更新四种机型：iPhone 12 mini、iPhone 12、iPhone 12 Pro、iPhone 12 Pro Max
    if ([platform isEqualToString:@"iPhone13,1"])   return  @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"])   return  @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])   return  @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"])   return  @"iPhone 12 Pro Max";
    
    if ([platform isEqualToString:@"iPhone14,2"])   return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone14,3"])   return @"iPhone 13 Pro Max";
    if ([platform isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone14,6"])   return @"iPhone SE 3";
    
    NSLog(@"Unknown iPhone: %@", platform);
    return platform;
}

#pragma mark - iPad
NSString *iPadPlatform(NSString *platform) {
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,5"])   return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,6"])   return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,11"])  return @"iPad 7";
    if ([platform isEqualToString:@"iPad7,12"])  return @"iPad 7";
    if ([platform isEqualToString:@"iPad11,6"])  return @"iPad 8";
    if ([platform isEqualToString:@"iPad11,7"])  return @"iPad 8";
    if ([platform isEqualToString:@"iPad12,1"])  return @"iPad 9";
    if ([platform isEqualToString:@"iPad12,2"])  return @"iPad 9";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad11,3"])  return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,4"])  return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad13,1"])  return @"iPad Air 4";
    if ([platform isEqualToString:@"iPad13,2"])  return @"iPad Air 4";
    if ([platform isEqualToString:@"iPad13,16"]) return @"iPad Air 5";
    if ([platform isEqualToString:@"iPad13,17"]) return @"iPad Air 5";
    
    //iPad Pro
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro 2 (12.9-inch)";
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro 2 (12.9-inch)";
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad8,1"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,2"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,3"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,4"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,5"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,6"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,7"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,8"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,9"])   return @"iPad Pro 2 (11-inch)";
    if ([platform isEqualToString:@"iPad8,10"])  return @"iPad Pro 2 (11-inch)";
    if ([platform isEqualToString:@"iPad8,11"])  return @"iPad Pro 4 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,12"])  return @"iPad Pro 4 (12.9-inch)";
    if ([platform isEqualToString:@"iPad13,4"])  return @"iPad Pro 3 (11-inch)";
    if ([platform isEqualToString:@"iPad13,5"])  return @"iPad Pro 3 (11-inch)";
    if ([platform isEqualToString:@"iPad13,6"])  return @"iPad Pro 3 (11-inch)";
    if ([platform isEqualToString:@"iPad13,7"])  return @"iPad Pro 3 (11-inch)";
    if ([platform isEqualToString:@"iPad13,8"])  return @"iPad Pro 5 (12.9-inch)";
    if ([platform isEqualToString:@"iPad13,9"])  return @"iPad Pro 5 (12.9-inch)";
    if ([platform isEqualToString:@"iPad13,10"]) return @"iPad Pro 5 (12.9-inch)";
    if ([platform isEqualToString:@"iPad13,11"]) return @"iPad Pro 5 (12.9-inch)";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad mini";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad11,1"])  return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad11,2"])  return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad14,1"])  return @"iPad mini 6";
    if ([platform isEqualToString:@"iPad14,2"])  return @"iPad mini 6";
    
    NSLog(@"Unknown iPad: %@", platform);
    return platform;
}

#pragma mark - iPod
NSString *iPodPlatform(NSString *platform) {
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod touch 2";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod touch 3";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod touch 4";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod touch 6";
    //2019年5月发布，更新一种机型：iPod touch (7th generation)
    if ([platform isEqualToString:@"iPod9,1"])      return @"iPod touch 7";

    NSLog(@"Unknown iPod: %@", platform);
    return platform;
}

#pragma mark - AirPods
NSString *AirPodsPlatform(NSString *platform) {
    if ([platform isEqualToString:@"AirPods1,1"])      return @"AirPods";
    if ([platform isEqualToString:@"AirPods1,2"])      return @"AirPods 2";
    if ([platform isEqualToString:@"AirPods2,1"])      return @"AirPods 2";
    if ([platform isEqualToString:@"AirPods1,3"])      return @"AirPods 3";
    if ([platform isEqualToString:@"Audio2,1"])        return @"AirPods 3";
    if ([platform isEqualToString:@"AirPods2,2"])      return @"AirPods Pro";
    if ([platform isEqualToString:@"AirPodsPro1,1"])   return @"AirPods Pro";
    if ([platform isEqualToString:@"iProd8,1"])        return @"AirPods Pro";
    if ([platform isEqualToString:@"iProd8,6"])        return @"AirPods Max";
    if ([platform isEqualToString:@"AirPodsMax1,1"])   return @"AirPods Max";

    NSLog(@"Unknown AirPods: %@", platform);
    return platform;
}

#pragma mark - AirTag
NSString *AirTagPlatform(NSString *platform){
    if ([platform isEqualToString:@"AirTag1,1"])       return @"AirTag";
    
    NSLog(@"Unknown AirTag: %@", platform);
    return platform;
}

#pragma mark - Apple TV
NSString *AppleTVPlatform(NSString *platform) {
    if ([platform isEqualToString:@"AppleTV1,1"])      return @"Apple TV";
    if ([platform isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([platform isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    if ([platform isEqualToString:@"AppleTV6,2"])      return @"Apple TV 4K";
    if ([platform isEqualToString:@"AppleTV11,1"])     return @"Apple TV 4K 2";

    NSLog(@"Unknown Apple TV: %@", platform);
    return platform;
}

#pragma mark - Apple Watch
NSString *AppleWatchPlatform(NSString *platform) {
    if ([platform isEqualToString:@"Watch1,1"])      return @"Apple Watch (38mm)";
    if ([platform isEqualToString:@"Watch1,2"])      return @"Apple Watch (42mm)";
    if ([platform isEqualToString:@"Watch2,6"])      return @"Apple Watch Series 1 (38mm)";
    if ([platform isEqualToString:@"Watch2,7"])      return @"Apple Watch Series 1 (42mm)";
    if ([platform isEqualToString:@"Watch2,3"])      return @"Apple Watch Series 2 (38mm)";
    if ([platform isEqualToString:@"Watch2,4"])      return @"Apple Watch Series 2 (42mm)";
    if ([platform isEqualToString:@"Watch3,1"])      return @"Apple Watch Series 3 (38mm)";
    if ([platform isEqualToString:@"Watch3,2"])      return @"Apple Watch Series 3 (42mm)";
    if ([platform isEqualToString:@"Watch3,3"])      return @"Apple Watch Series 3 (38mm)";
    if ([platform isEqualToString:@"Watch3,4"])      return @"Apple Watch Series 3 (42mm)";
    //2018年9月发布，更新一种机型：Apple Watch S4
    if ([platform isEqualToString:@"Watch4,1"])      return @"Apple Watch Series 4 (40mm)";
    if ([platform isEqualToString:@"Watch4,2"])      return @"Apple Watch Series 4 (44mm)";
    if ([platform isEqualToString:@"Watch4,3"])      return @"Apple Watch Series 4 (40mm)";
    if ([platform isEqualToString:@"Watch4,4"])      return @"Apple Watch Series 4 (44mm)";
    //2019年9月发布，更新一种机型：Apple Watch S5
    if ([platform isEqualToString:@"Watch5,1"])      return @"Apple Watch Series 5 (40mm)";
    if ([platform isEqualToString:@"Watch5,2"])      return @"Apple Watch Series 5 (44mm)";
    if ([platform isEqualToString:@"Watch5,3"])      return @"Apple Watch Series 5 (40mm)";
    if ([platform isEqualToString:@"Watch5,4"])      return @"Apple Watch Series 5 (44mm)";
    //2020年9月发布，更新两种机型：Apple Watch SE、Apple Watch S6
    if ([platform isEqualToString:@"Watch5,9"])      return @"Apple Watch SE (40mm)";
    if ([platform isEqualToString:@"Watch5,10"])     return @"Apple Watch SE (44mm)";
    if ([platform isEqualToString:@"Watch5,11"])     return @"Apple Watch SE (40mm)";
    if ([platform isEqualToString:@"Watch5,12"])     return @"Apple Watch SE (44mm)";
    if ([platform isEqualToString:@"Watch6,1"])      return @"Apple Watch Series 6 (40mm)";
    if ([platform isEqualToString:@"Watch6,2"])      return @"Apple Watch Series 6 (44mm)";
    if ([platform isEqualToString:@"Watch6,3"])      return @"Apple Watch Series 6 (40mm)";
    if ([platform isEqualToString:@"Watch6,4"])      return @"Apple Watch Series 6 (44mm)";
    
    if ([platform isEqualToString:@"Watch6,6"])      return @"Apple Watch Series 7 (41mm)";
    if ([platform isEqualToString:@"Watch6,7"])      return @"Apple Watch Series 7 (45mm)";
    if ([platform isEqualToString:@"Watch6,8"])      return @"Apple Watch Series 7 (41mm)";
    if ([platform isEqualToString:@"Watch6,9"])      return @"Apple Watch Series 7 (45mm)";

    NSLog(@"Unknown Apple Watch: %@", platform);
    return platform;
}

#pragma mark - HomePod
NSString *HomePodPlatform(NSString *platform) {
    // 2017年6月发布，更新一种机型：HomePod
    if ([platform isEqualToString:@"AudioAccessory1,1"])      return @"HomePod";
    if ([platform isEqualToString:@"AudioAccessory1,2"])      return @"HomePod";
    //TODO:2020年10月发布，更新一种机型：HomePod mini
    if ([platform isEqualToString:@"AudioAccessory5,1"])      return @"HomePod mini";

    NSLog(@"Unknown HomePod: %@", platform);
    return platform;
}

#pragma mark - MAC Address
- (NSString *)br_macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    free(buf);
    return outstring;
}

#pragma mark - 获取设备内网IP（局域网IP）此法只能获取到WiFi环境下的本地IP
- (NSString *)br_deviceIPAddress {
    NSString *address = @"手机移动网络";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( (*temp_addr).ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    // NSLog(@"手机的IP是：%@", address);
    
    return address;
}

#pragma mark - 获取设备外网IP（公网IP）
- (NSString *)br_WANIPAddress {
    /**
         这里只介绍获取公网ip的几个地址：
         1、新浪：https://pv.sohu.com/cityjson?ie=utf-8
         2、淘宝：https://www.taobao.com/help/getip.php
         3、https://www.fbisb.com/ip.php
         4、http://ifconfig.me/ip
    */
    NSURL *ipURL = [NSURL URLWithString:@"https://pv.sohu.com/cityjson?ie=utf-8"];
    NSError *error = nil;
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    // 判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        // 对字符串进行处理，然后进行json解析，删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length - 1];
        // 将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        return dict[@"cip"] ? dict[@"cip"] : @"";
    }
    return @"";
}

#pragma mark sysctlbyname utils
- (NSString *)getSysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

#pragma mark sysctl utils
- (NSUInteger)getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger)cpuFrequency {
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger)busFrequency {
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger)cpuCount {
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger)totalMemory {
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger)userMemory {
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger)maxSocketBufferSize {
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
*/
- (NSNumber *)totalDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *)freeDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

//#pragma mark - 获取广告唯一标识
//- (void)br_getIDFAString:(void (^)(NSString *idfaString))successBlock failureBlock:(void (^)(void))failureBlock {
//    if (@available(iOS 14, *)) {
//        // iOS14及以上版本需要先请求权限
//        /**
//            iOS14及以上：需要在info.plist文件添加跟踪权限请求描述文字
//            <key>NSUserTrackingUsageDescription</key>
//            <string>此标识符将用于向您推荐个性化广告。</string>
//         */
//        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//            // 获取到权限后，依然使用老方法获取idfa
//            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
//                NSString *idfaString = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//                successBlock ? successBlock(idfaString) : nil;
//            } else {
//                NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
//                failureBlock ? failureBlock() : nil;
//            }
//        }];
//    } else {
//        // iOS14以下版本依然使用老方法
//        // 判断在设置-隐私里用户是否打开了广告跟踪
//        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
//            NSString *idfaString = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//            successBlock ? successBlock(idfaString) : nil;
//        } else {
//            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
//            failureBlock ? failureBlock() : nil;
//        }
//    }
//}

@end
