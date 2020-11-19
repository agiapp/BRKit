//
//  UIDevice+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UIDevice+BRAdd.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
// 下面是获取IP需要的头文件
#import <sys/ioctl.h>
#include <ifaddrs.h>
#import <arpa/inet.h>

@implementation UIDevice (BRAdd)

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
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]){
        return @"Simulator";//注意：请使用真机测试，使用模拟器会返回Simulator（与模拟器所对应的机型无关）
    }
    if([platform rangeOfString:@"iPhone"].location != NSNotFound){
        return iPhonePlatform(platform);
    }
    if([platform rangeOfString:@"iPad"].location != NSNotFound){
        return iPadPlatform(platform);
    }
    if([platform rangeOfString:@"iPod"].location != NSNotFound){
        return iPodPlatform(platform);
    }
    if([platform rangeOfString:@"AirPods"].location != NSNotFound){
        return AirPodsPlatform(platform);
    }
    if([platform rangeOfString:@"AppleTV"].location != NSNotFound){
        return AppleTVPlatform(platform);
    }
    if([platform rangeOfString:@"Watch"].location != NSNotFound){
        return AppleWatchPlatform(platform);
    }
    if([platform rangeOfString:@"AudioAccessory"].location != NSNotFound){
        return HomePodPlatform(platform);
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
    if ([platform isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])  return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])  return @"iPhone X";
    //2018年10月发布，更新三种机型：iPhone XR、iPhone XS、iPhone XS Max
    if ([platform isEqualToString:@"iPhone11,8"])  return  @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])  return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])  return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])  return @"iPhone XS Max";
    //2019年9月发布，更新三种机型：iPhone 11、iPhone 11 Pro、iPhone 11 Pro Max
    if ([platform isEqualToString:@"iPhone12,1"])  return  @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])  return  @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])  return  @"iPhone 11 Pro Max";
    //2020年4月发布，更新一种机型：iPhone SE2
    if ([platform isEqualToString:@"iPhone12,8"])  return  @"iPhone SE2";
    //2020年10月发布，更新四种机型：iPhone 12 mini、iPhone 12、iPhone 12 Pro、iPhone 12 Pro Max
    if ([platform isEqualToString:@"iPhone13,1"])  return  @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"])  return  @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])  return  @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"])  return  @"iPhone 12 Pro Max";
    
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
    if ([platform isEqualToString:@"iPad7,11"])   return @"iPad 7";
    if ([platform isEqualToString:@"iPad7,12"])   return @"iPad 7";
    if ([platform isEqualToString:@"iPad11,6"])   return @"iPad 8";
    if ([platform isEqualToString:@"iPad11,7"])   return @"iPad 8";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad11,3"])   return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,4"])   return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad13,1"])   return @"iPad Air 4";
    if ([platform isEqualToString:@"iPad13,2"])   return @"iPad Air 4";
    
    //iPad Pro
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch) ";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch) ";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch)";
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
    if ([platform isEqualToString:@"iPad8,10"])   return @"iPad Pro 2 (11-inch)";
    if ([platform isEqualToString:@"iPad8,11"])   return @"iPad Pro 4 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,12"])   return @"iPad Pro 4 (12.9-inch)";
    
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
    if ([platform isEqualToString:@"iPad11,1"])   return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad11,2"])   return @"iPad mini 5";

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
    if ([platform isEqualToString:@"AirPods2,1"])      return @"AirPods 2";
    if ([platform isEqualToString:@"AirPods8,1"])      return @"AirPods Pro";

    NSLog(@"Unknown AirPods: %@", platform);
    return platform;
}

#pragma mark - Apple TV
NSString *AppleTVPlatform(NSString *platform) {
    if ([platform isEqualToString:@"AppleTV1,1"])      return @"Apple TV";
    if ([platform isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([platform isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    if ([platform isEqualToString:@"AppleTV6,2"])      return @"Apple TV 4K ";

    NSLog(@"Unknown Apple TV: %@", platform);
    return platform;
}

#pragma mark - Apple Watch
NSString *AppleWatchPlatform(NSString *platform) {
    if ([platform isEqualToString:@"Watch1,1"])      return @"Apple Watch";
    if ([platform isEqualToString:@"Watch1,2"])      return @"Apple Watch";
    if ([platform isEqualToString:@"Watch2,6"])      return @"Apple Watch Series 1";
    if ([platform isEqualToString:@"Watch2,7"])      return @"Apple Watch Series 1";
    if ([platform isEqualToString:@"Watch2,3"])      return @"Apple Watch Series 2";
    if ([platform isEqualToString:@"Watch2,4"])      return @"Apple Watch Series 2";
    if ([platform isEqualToString:@"Watch3,1"])      return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,2"])      return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,3"])      return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,4"])      return @"Apple Watch Series 3";
    //2018年9月发布，更新一种机型：Apple Watch S4
    if ([platform isEqualToString:@"Watch4,1"])      return @"Apple Watch Series 4";
    if ([platform isEqualToString:@"Watch4,2"])      return @"Apple Watch Series 4";
    if ([platform isEqualToString:@"Watch4,3"])      return @"Apple Watch Series 4";
    if ([platform isEqualToString:@"Watch4,4"])      return @"Apple Watch Series 4";
    //2019年9月发布，更新一种机型：Apple Watch S5
    if ([platform isEqualToString:@"Watch5,1"])      return @"Apple Watch Series 5";
    if ([platform isEqualToString:@"Watch5,2"])      return @"Apple Watch Series 5";
    if ([platform isEqualToString:@"Watch5,3"])      return @"Apple Watch Series 5";
    if ([platform isEqualToString:@"Watch5,4"])      return @"Apple Watch Series 5";
    //2020年9月发布，更新两种机型：Apple Watch SE、Apple Watch S6
    if ([platform isEqualToString:@"Watch5,9"])      return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch5,10"])      return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch5,11"])      return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch5,12"])      return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch6,1"])      return @"Apple Watch Series 6";
    if ([platform isEqualToString:@"Watch6,2"])      return @"Apple Watch Series 6";
    if ([platform isEqualToString:@"Watch6,3"])      return @"Apple Watch Series 6";
    if ([platform isEqualToString:@"Watch6,4"])      return @"Apple Watch Series 6";

    NSLog(@"Unknown Apple Watch: %@", platform);
    return platform;
}

#pragma mark - HomePod
NSString *HomePodPlatform(NSString *platform) {
    // 2017年6月发布，更新一种机型：HomePod
    if ([platform isEqualToString:@"AudioAccessory1,1"])      return @"HomePod";
    if ([platform isEqualToString:@"AudioAccessory1,2"])      return @"HomePod";
    //TODO:2020年10月发布，更新一种机型：HomePod mini
//    if ([platform isEqualToString:@"AudioAccessory"])      return @"HomePod mini";

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

#pragma mark - IP Address
- (NSString *)br_ipAddresses {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for(ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if(ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if(ifr->ifr_addr.sa_family != AF_INET) continue;
            if((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if(strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for(int i=0; i < ips.count; i++) {
        if(ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
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

@end
