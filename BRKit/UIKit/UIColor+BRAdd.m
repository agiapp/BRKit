//
//  UIColor+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UIColor+BRAdd.h"
#import "NSString+BRAdd.h"
#import "BRKitMacro.h"

BRSYNTH_DUMMY_CLASS(UIColor_BRAdd)

@implementation UIColor (BRAdd)

#pragma mark - 创建颜色对象（16进制的RGB值）
+ (UIColor *)br_colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

#pragma mark - 创建颜色对象（16进制的RGB值 + 不透明度值）
+ (UIColor *)br_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}

#pragma mark - 创建颜色对象（颜色的16进制字符串值）
// 有效格式：#RRGGBB、#RGB、#RRGGBBAA、#RGBA、0xRGB、RRGGBB ...（"#"和"0x"前缀可以省略不写）
+ (instancetype)br_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (br_hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

static BOOL br_hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str br_stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    // RGB, RGBA, RRGGBB, RRGGBBAA
    if (length < 5) {
        *r = br_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = br_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = br_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = br_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = br_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = br_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = br_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = br_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

static inline NSUInteger br_hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

+ (UIColor *)br_gradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withHeight:(CGFloat)height {
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, (id)toColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}



//================================================= 动态颜色 =================================================

#pragma mark - 系统背景颜色1：systemBackgroundColor
+ (UIColor *)br_systemBackgroundColor {
    if (@available(iOS 13.0, *)) {
        // #ffffff(正常)、#000000(深色)
        return [UIColor systemBackgroundColor];
    } else {
        return [UIColor whiteColor];
    }
}

#pragma mark - 系统背景颜色2：secondarySystemBackgroundColor
+ (UIColor *)br_secondarySystemBackgroundColor {
    if (@available(iOS 13.0, *)) {
        // #f2f2f7(正常)、#1c1c1e(深色)
        return [UIColor secondarySystemBackgroundColor];
    } else {
        return [UIColor br_colorWithHexString:@"#f2f2f7"];
    }
}

#pragma mark - 系统背景颜色3：tertiarySystemBackgroundColor
+ (UIColor *)br_tertiarySystemBackgroundColor {
    if (@available(iOS 13.0, *)) {
        // #ffffff(正常)、#2c2c2e(深色)
        return [UIColor tertiarySystemBackgroundColor];
    } else {
        return [UIColor whiteColor];
    }
}

#pragma mark - Grouped 背景颜色1（如，UITableView 背景颜色）：systemGroupedBackgroundColor
+ (UIColor *)br_systemGroupedBackgroundColor {
    if (@available(iOS 13.0, *)) {
        // #f2f2f7(正常)、#000000(深色)
        return [UIColor systemGroupedBackgroundColor];
    } else {
        return [UIColor groupTableViewBackgroundColor];
    }
}

#pragma mark - Grouped 背景颜色2（如，UITableViewCell 背景颜色）：secondarySystemGroupedBackgroundColor
+ (UIColor *)br_secondarySystemGroupedBackgroundColor {
    if (@available(iOS 13.0, *)) {
        // #ffffff(正常)、#1c1c1e(深色)
        return [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        return [UIColor whiteColor];
    }
}

#pragma mark - Grouped 背景颜色3：tertiarySystemGroupedBackgroundColor
+ (UIColor *)br_tertiarySystemGroupedBackgroundColor {
    if (@available(iOS 13.0, *)) {
        // #f2f2f7(正常)、#2c2c2e(深色)
        return [UIColor tertiarySystemGroupedBackgroundColor];
    } else {
        return [UIColor br_colorWithHexString:@"#f2f2f7"];
    }
}

#pragma mark - 边框线背景颜色（有透明度）：separatorColor
+ (UIColor *)br_separatorColor {
    if (@available(iOS 13.0, *)) {
        // 边框线背景颜色，有透明度
        return [UIColor separatorColor];
    } else {
        return [UIColor br_colorWithHexString:@"#c6c6c8"];
    }
}

#pragma mark - 分隔线背景颜色（无透明度）：opaqueSeparatorColor
+ (UIColor *)br_opaqueSeparatorColor {
    if (@available(iOS 13.0, *)) {
        // 分割线背景颜色，无透明度
        return [UIColor opaqueSeparatorColor];
    } else {
        return [UIColor br_colorWithHexString:@"#c6c6c8"];
    }
}

#pragma mark - 文本颜色1：labelColor
+ (UIColor *)br_labelColor {
    if (@available(iOS 13.0, *)) {
        // #000000(正常)、#ffffff(深色)
        return [UIColor labelColor];
    } else {
        return [UIColor blackColor];
    }
}

#pragma mark - 文本颜色2：secondaryLabelColor
+ (UIColor *)br_secondaryLabelColor {
    if (@available(iOS 13.0, *)) {
        // #8a8a8e(正常)、#8d8d92/#98989e(深色)
        return [UIColor secondaryLabelColor];
    } else {
        return [UIColor br_colorWithHexString:@"#8a8a8e"];
    }
}

#pragma mark - 文本颜色3：tertiaryLabelColor
+ (UIColor *)br_tertiaryLabelColor {
    if (@available(iOS 13.0, *)) {
        // #c4c4c6(正常)、#47474a/#5a5a5e(深色)
        return [UIColor tertiaryLabelColor];
    } else {
        return [UIColor br_colorWithHexString:@"#c4c4c6"];
    }
}

#pragma mark - 超链接文本颜色：linkColor
+ (UIColor *)br_linkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor linkColor];
    } else {
        return [UIColor br_colorWithHexString:@"#2c7cf6"];
    }
}

#pragma mark - 占位文本颜色：placeholderTextColor（等于 tertiaryLabelColor）
+ (UIColor *)br_placeholderTextColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor placeholderTextColor];
    } else {
        return [UIColor br_colorWithHexString:@"#c4c4c6"];
    }
}

#pragma mark - 创建自定义动态颜色（适配深色模式）
+ (UIColor *)br_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if ([traitCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return lightColor;
            } else {
                return darkColor;
            }
        }];
        return dyColor;
    } else {
        return lightColor;
    }
}


@end
