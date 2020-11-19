//
//  NSString+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/4/19.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSString+BRAdd.h"
#include <CommonCrypto/CommonCrypto.h>
#import "BRKitMacro.h"

BRSYNTH_DUMMY_CLASS(NSString_BRAdd)

@implementation NSString (BRAdd)

#pragma mark - 判断是否是有效的(非空/非空白)字符串
// @"(null)", @"null", nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
- (BOOL)br_isValidString {
    // 1. 判断是否是 非空字符串
    if (self == nil ||
        [self isEqual:[NSNull null]] ||
        [self isEqual:@"(null)"] ||
        [self isEqual:@"null"]) {
        return NO;
    }
    // 2. 判断是否是 非空白字符串
    if ([[self br_stringByTrim] length] == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - 获取有效参数字符串
- (NSString *)br_PramsString {
    if ([self br_isValidString]) {
        return self;
    }
    return nil;
}

#pragma mark - 判断是否包含指定字符串
- (BOOL)br_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

#pragma mark - 修剪字符串（去掉头尾两边的空格和换行符）
- (NSString *)br_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

#pragma mark - md5加密（32位小写）
- (NSString *)br_md5String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_BLOCK_BYTES];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    return [md5Str lowercaseString];
}

#pragma mark - md5加密（16位小写）
- (NSString *)br_md5String16 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11]
                        ];
    return [md5Str lowercaseString];
}

#pragma mark - sha1加密（小写）
- (NSString *)br_sha1String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *sha1Str = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [sha1Str appendFormat:@"%02x", result[i]];
    }
    return sha1Str;
}

#pragma mark - 返回一个新的UUID字符串
+ (NSString *)br_UUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

#pragma mark - UTF-8字符串编码
- (NSString *)br_stringByUTF8Encode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - UTF-8字符串解码
- (NSString *)br_stringByUTF8Decode {
    return [self stringByRemovingPercentEncoding];
}

#pragma mark - 获取文本的大小
- (CGSize)br_getTextSize:(UIFont *)font maxSize:(CGSize)maxSize mode:(NSLineBreakMode)lineBreakMode {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    // 计算文本的的rect
    CGRect rect = [self boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}

#pragma mark - 获取文本的宽度
- (CGFloat)br_getTextWidth:(UIFont *)font height:(CGFloat)height {
    CGSize size = [self br_getTextSize:font maxSize:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByWordWrapping];
    return size.width;
}

#pragma mark - 获取文本的高度
- (CGFloat)br_getTextHeight:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self br_getTextSize:font maxSize:CGSizeMake(width, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.height;
}

#pragma mark - 获取文本的高度（带行间距）
- (CGFloat)br_getTextHeight:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = font;
    if (lineSpacing > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        // 段落行间距
        paragraphStyle.lineSpacing = lineSpacing;
        // 在单个字符边界处换行
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    // 计算文本的的rect
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}

#pragma mark - label富文本: 插入图片
- (NSMutableAttributedString *)br_setRichTextWithImage:(NSString *)iconName bounds:(CGRect)bounds iconLocation:(NSInteger)location {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    // 文本附件
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 定义图片内容及位置和大小（y为负值可以向上移动图片）
    attch.image = [UIImage imageNamed:iconName];
    attch.bounds = bounds;
    // 创建带有图片的富文本
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
    // 将图片插入指定位置
    [attrString insertAttributedString:imageStr atIndex:location];
    return attrString;
}

#pragma mark - label富文本: 设置不同字体和颜色
- (NSMutableAttributedString *)br_setChangeText:(NSString *)changeText changeFont:(nullable UIFont *)font changeTextColor:(nullable UIColor *)color {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    if (![changeText br_isValidString]) {
        return attrString;
    }
    // 获取要调整文字样式的位置
    NSRange range = [[attrString string]rangeOfString:changeText];
    if (font) {
        // 设置不同字体
        [attrString addAttribute:NSFontAttributeName value:font range:range];
    }
    if (color) {
        // 设置不同颜色
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return attrString;
}

#pragma mark - label富文本: 设置不同颜色和行高
- (NSMutableAttributedString *)br_setChangeText:(NSString *)changeText
                                changeTextColor:(UIColor *)color
                                    lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    if (![changeText br_isValidString]) {
        return attrString;
    }
    // 获取要调整文字样式的位置
    NSRange range = [[attrString string]rangeOfString:changeText];
    if (color) {
        // 设置不同颜色
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    if (lineSpacing > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        // 行间距
        paragraphStyle.lineSpacing = lineSpacing;
        // 显示不下在末尾显示省略号
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[attrString string] length])];
    }
    
    return attrString;
}

#pragma mark - 设置所有关键词自定义颜色显示
- (NSMutableAttributedString *)br_setAllChangeText:(NSString *)changeText changeFont:(nullable UIFont *)font changeTextColor:(nullable UIColor *)color {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    if (![changeText br_isValidString]) {
        return attrString;
    }
    NSArray *rangeArr = [self br_rangeArrayOfSubString:changeText];
    for (NSInteger i = 0; i < rangeArr.count; i++) {
        NSRange range = [rangeArr[i] rangeValue];
        if (font) {
            // 设置不同字体
            [attrString addAttribute:NSFontAttributeName value:font range:range];
        }
        if (color) {
            // 设置不同颜色
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    return attrString;
}

#pragma mark - 获取字符串中多个相同字符串的所有range
- (NSArray *)br_rangeArrayOfSubString:(NSString *)searchString {
    NSMutableArray *rangeArr = [NSMutableArray array];
    NSString *string1 = [self stringByAppendingString:searchString];
    NSString *temp = nil;
    for (NSInteger i = 0; i < (self.length - searchString.length + 1); i++) {
        temp = [string1 substringWithRange:NSMakeRange(i, searchString.length)];
        if ([temp isEqualToString:searchString]) {
            NSRange range = {i, searchString.length};
            [rangeArr addObject: [NSValue valueWithRange:range]];
        }
    }
    return rangeArr;
}


#pragma mark - label富文本: HTML标签文本（HTMLString 转化为NSAttributedString）
- (NSMutableAttributedString *)br_setTextHTMLString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithData:data options:options documentAttributes:nil error:nil];

    return attributedStr;
}

#pragma mark - label富文本: 添加中划线
- (NSMutableAttributedString *)br_setTextLineThrough {
    // 中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    return attribtStr;
}

#pragma mark - 设置文本关键词红色显示
// 美国<em>苹果</em> <em>科技</em>有限公司
- (NSAttributedString *)br_setTextKeywords:(UIColor *)keywordColor {
    NSString *formatText = [[self stringByReplacingOccurrencesOfString:@"<em>" withString:@""] stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formatText];
    NSArray <NSString *>* textArr = [self componentsSeparatedByString:@"<em>"];
    for (NSInteger i = 0; i < textArr.count; i++) {
        if ([textArr[i] br_containsString:@"</em>"]) {
            NSString *keyword = [[textArr[i] componentsSeparatedByString:@"</em>"] firstObject];
            // 只会得到第一个关键字的位置
            NSRange range = [formatText rangeOfString:keyword];
            [attributedString addAttribute:NSForegroundColorAttributeName value:keywordColor range:range];
        }
    }
    return [attributedString copy];
}

#pragma mark - label富文本: 段落样式
- (NSAttributedString *)br_paragraphText {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 段落行间距
    paragraphStyle.lineSpacing = 7;
    // 段落行高
    //paragraphStyle.lineHeightMultiple = 1.5;
    // 段落间距
    paragraphStyle.paragraphSpacing = 12;
    // 首行缩进
    paragraphStyle.firstLineHeadIndent = 28;
    // 在单个字符边界处换行
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[attrString string] length])];
    
    return [attrString copy];
}

#pragma mark - label富文本: 设置文本行间距
- (NSAttributedString *)br_textWithLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 段落行间距
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    // 在单个字符边界处换行
    //paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[attrString string] length])];
    
    return [attrString copy];
}

#pragma mark - 获取段落文本的高度
- (CGFloat)br_getParagraphTextHeight:(UIFont *)font width:(CGFloat)width {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = font;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 段落行间距
    paragraphStyle.lineSpacing = 7;
    // 段落行高
    //paragraphStyle.lineHeightMultiple = 1.5;
    // 段落间距
    paragraphStyle.paragraphSpacing = 12;
    // 首行缩进
    paragraphStyle.firstLineHeadIndent = 28;
    // 在单个字符边界处换行
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    // 计算文本的的rect
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}

///==================================================
///             正则表达式
///==================================================

#pragma mark - 检查字符串是否匹配正则表达式格式
- (BOOL)br_checkStringWithRegex:(NSString *)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicte evaluateWithObject:self];
}

#pragma mark - 判断是否是正整数
- (BOOL)br_isValidUInteger {
    NSString *regex = @"^[1-9]\\d*$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是小数，且最多保留两位小数
- (BOOL)br_isValidTwoFloat {
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是有效的手机号
- (BOOL)br_isValidPhoneNumber {
    NSString *regex = @"^(1[3-9][0-9])\\d{8}$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是有效的用户密码
- (BOOL)br_isValidPassword {
    // 以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~18
    NSString *regex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,18}$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是有效的用户名（20位的中文或英文）
- (BOOL)br_isValidUserName {
    NSString *regex = @"^[a-zA-Z一-龥]{1,20}";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是有效的邮箱
- (BOOL)br_isValidEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是有效的URL
- (BOOL)br_isValidUrl {
    NSString *regex = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是有效的银行卡号
- (BOOL)br_isValidBankNumber {
    NSString *regex =@"^\\d{16,19}$|^\\d{6}[- ]\\d{10,13}$|^\\d{4}[- ]\\d{4}[- ]\\d{4}[- ]\\d{4,7}$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是有效的身份证号
- (BOOL)br_isValidIDCardNumber {
    NSString *value = self;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value) {
        return NO;
    } else {
        length = value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue + 1900;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                NSString *validateData = [value substringWithRange:NSMakeRange(17,1)];
                validateData = [validateData uppercaseString];
                if ([M isEqualToString:validateData]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        default:
            return false;
    }
}

#pragma mark - 判断是否是有效的IP地址
- (BOOL)br_isValidIPAddress {
    NSString *regex = [NSString stringWithFormat:@"^(\\\\d{1,3})\\\\.(\\\\d{1,3})\\\\.(\\\\d{1,3})\\\\.(\\\\d{1,3})$"];
    BOOL rc = [self br_checkStringWithRegex:regex];
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}

#pragma mark - 判断是否是纯汉字
- (BOOL)br_isValidChinese {
    NSString *regex = @"^[\\u4e00-\\u9fa5]+$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是邮政编码
- (BOOL)br_isValidPostalcode {
    NSString *regex = @"^[0-8]\\\\d{5}(?!\\\\d)$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是工商税号
- (BOOL)br_isValidTaxNo {
    NSString *regex = @"[0-9]\\\\d{13}([0-9]|X)$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 判断是否是车牌号
- (BOOL)br_isCarNumber {
    // 车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    // 其中\\u4e00-\\u9fa5表示unicode编码中汉字已编码部分，\\u9fa5-\\u9fff是保留部分，将来可能会添加
    NSString *regex = @"^[\\u4e00-\\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fff]$";
    return [self br_checkStringWithRegex:regex];
}

#pragma mark - 通过身份证获取性别
- (NSNumber *)br_getGenderFromIDCard {
    if (self.length < 16) return nil;
    NSUInteger lenght = self.length;
    NSString *sex = [self substringWithRange:NSMakeRange(lenght - 2, 1)];
    if ([sex intValue] % 2 == 1) {
        return @1;
    }
    return @2;
}

#pragma mark - 隐藏证件号指定位数字
- (NSString *)br_hideCharacters:(NSUInteger)location length:(NSUInteger)length {
    if (self.length > length && length > 0) {
        NSMutableString *str = [[NSMutableString alloc]init];
        for (NSInteger i = 0; i < length; i++) {
            [str appendString:@"*"];
        }
        return [self stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:[str copy]];
    }
    return self;
}

@end
