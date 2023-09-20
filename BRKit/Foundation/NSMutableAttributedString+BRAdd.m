//
//  NSMutableAttributedString+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSMutableAttributedString+BRAdd.h"
#import "NSString+BRAdd.h"
#import <objc/runtime.h>

@interface NSMutableAttributedString ()
/** 记录要改变的Range（即当前要修改的文本范围），为空时就设置的是全部字符串 */
@property(nonatomic, assign) NSRange changeRange;

@end

@implementation NSMutableAttributedString (BRAdd)

/**
 *  创建 NSMutableAttributedString 对象
 */
+ (NSMutableAttributedString *(^)(NSString *text))br_attributedString {
    // 声明并实现一个block，并返回
    return ^(NSString *text) {
        return [[NSMutableAttributedString alloc] initWithString:text];
    };
}

/**
 *  设置字符串的样式
 *  @param  block  里面用make.各种想要的设置
 */
- (void)br_makeCalculators:(void (^)(NSMutableAttributedString *make))block {
    // block 链式调用
    block ? block(self) : nil;
}

/**
 *  设置子字符串的样式
 *  @param  subString   子字符串数
 *  @param  block       里面用make.各种想要的设置
 */
- (void)br_changeSubString:(NSString *)subString makeCalculators:(void (^)(NSMutableAttributedString *make))block {
    NSArray *rangeArr = [self.string br_getRangeArrayOfSubString:subString];
    for (NSNumber *rangeObj in rangeArr) {
        // 设置修改range
        self.changeRange = [rangeObj rangeValue];
        // block 链式调用
        block ? block(self) : nil;
    }
    // 重置为空，为空就设置全部字符串
    self.changeRange = NSMakeRange(0, 0);
}

/**
 *  设置多个子字符串的样式
 *  @param  subStrings  子字符串数组
 *  @param  block       里面用make.各种想要的设置
 */
- (void)br_changeSubStrings:(NSArray *)subStrings makeCalculators:(void (^)(NSMutableAttributedString *make))block {
    for (NSString *subString in subStrings) {
        NSArray *rangeArr = [self.string br_getRangeArrayOfSubString:subString];
        for (NSNumber *rangeObj in rangeArr) {
            // 设置修改range
            self.changeRange = [rangeObj rangeValue];
            // block 链式调用
            block ? block(self) : nil;
        }
    }
    // 重置为空，为空就设置全部字符串
    self.changeRange = NSMakeRange(0, 0);
}

/**
 *  设置标签内字符串的样式
 *  @param  tagString  标签字符串（如：em，表示设置<em></em>标签内字符串的样式）
 *  @param  block   里面用make.各种想要的设置
 */
- (void)br_changeTagString:(NSString *)tagString makeCalculators:(void (^)(NSMutableAttributedString *make))block {
    NSMutableArray *rangeArr = [[NSMutableArray alloc]init];
    NSString *startTag = [NSString stringWithFormat:@"<%@>", tagString];
    NSString *endTag = [NSString stringWithFormat:@"</%@>", tagString];
    while ([self.string br_containsString:startTag]) {
        NSRange startRange = [self.string rangeOfString:startTag];
        NSRange endRange = [self.string rangeOfString:endTag];
        
        NSInteger keywordLocation = startRange.location;
        NSInteger keywordLength = endRange.location - (startRange.location + startRange.length);
        NSRange keywordRange = NSMakeRange(keywordLocation, keywordLength);
        [rangeArr addObject:[NSNumber valueWithRange:keywordRange]];
        
        [self deleteCharactersInRange:endRange];
        [self deleteCharactersInRange:startRange];
        
        // 设置修改range
        self.changeRange = keywordRange;
        // block 链式调用
        block ? block(self) : nil;
    }
    // 重置为空，为空就设置全部字符串
    self.changeRange = NSMakeRange(0, 0);
}

/**
 *  <em>标签内字符串标记颜色显示（一般用于搜索结果展示）
 *  如：@"美国<em>苹果</em>公司"，@"苹果"关键词标红显示
 */
- (NSMutableAttributedString *(^)(UIColor *))br_emTagString {
    return ^NSMutableAttributedString *(UIColor *keywordColor) {
        
        NSMutableArray *rangeArr = [[NSMutableArray alloc]init];
        NSString *startTag = @"<em>";
        NSString *endTag = @"</em>";
        while ([self.string br_containsString:startTag]) {
            // 第一个关键词的位置
            NSRange startRange = [self.string rangeOfString:startTag];
            NSRange endRange = [self.string rangeOfString:endTag];
            
            NSInteger keywordLocation = startRange.location;
            NSInteger keywordLength = endRange.location - (startRange.location + startRange.length);
            NSRange keywordRange = NSMakeRange(keywordLocation, keywordLength);
            [rangeArr addObject:[NSNumber valueWithRange:keywordRange]];
            
            [self deleteCharactersInRange:endRange];
            [self deleteCharactersInRange:startRange];
            
            [self addAttribute:NSForegroundColorAttributeName value:keywordColor range:keywordRange];
        }
        
        return self;
    };
}

/**
 多个AttributedString连接
 */
- (void)br_appendAttributedStrings:(NSArray *)attrStrings {
    for (NSAttributedString *attributedString in attrStrings) {
        [self appendAttributedString:attributedString];
    }
}

/**
 多个AttributedString连接
 */
+ (NSMutableAttributedString *)br_appendAttributedStrings:(NSArray *)attrStrings {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    [attributedString br_appendAttributedStrings:attrStrings];
    return attributedString;
}

#pragma mark - Private Methods
- (void)br_addAttribute:(NSString *)name value:(id)value {
    NSRange range = [self range];
    if (range.length > 0) {
        [self addAttribute:name value:value range:range];
    } else {
        NSLog(@"AttributedString的string为空，注意!!!");
    }
}

- (NSMutableParagraphStyle *)br_paragraphStyle {
    NSRange range = [self range];
    if (range.length > 0) {
        NSDictionary *dic = [self attributesAtIndex:0 effectiveRange:&range];
        NSMutableParagraphStyle *paragraphStyle = dic[@"NSParagraphStyle"];
        //如果字符串里面没有paragraphStyle，new一个新的
        if (!paragraphStyle) {
            paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        }
        return paragraphStyle;
    } else {
        NSLog(@"AttributedString的string为空，注意!!!");
        return nil;
    }
}

#pragma mark - 设置各种配置参数
// 颜色
- (NSMutableAttributedString *(^)(UIColor *))br_color {
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSForegroundColorAttributeName value:obj];
        return self;
    };
}

// 颜色（指定范围）
- (NSMutableAttributedString *(^)(UIColor *, NSRange))br_colorRange {
    return ^NSMutableAttributedString *(UIColor *color, NSRange range) {
        self.changeRange = range;
        [self br_addAttribute:NSForegroundColorAttributeName value:color];
        // 重置为空，为空就设置全部字符串
        self.changeRange = NSMakeRange(0, 0);
        return self;
    };
}

// br_bgColor(背景颜色)
- (NSMutableAttributedString *(^)(UIColor *))br_bgColor {
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSBackgroundColorAttributeName value:obj];
        return self;
    };
}

// 字体
- (NSMutableAttributedString *(^)(UIFont *))br_font {
    return ^NSMutableAttributedString *(UIFont *font) {
        [self br_addAttribute:NSFontAttributeName value:font];
        return self;
    };
}

// 字体（指定范围）
- (NSMutableAttributedString *(^)(UIFont *, NSRange))br_fontRange {
    return ^NSMutableAttributedString *(UIFont *font, NSRange range) {
        self.changeRange = range;
        [self br_addAttribute:NSFontAttributeName value:font];
        // 重置为空，为空就设置全部字符串
        self.changeRange = NSMakeRange(0, 0);
        return self;
    };
}

// 偏移量
- (NSMutableAttributedString *(^)(CGFloat ))br_baselineOffset {
    return ^NSMutableAttributedString *(CGFloat obj) {
        [self br_addAttribute:NSBaselineOffsetAttributeName value:@(obj)];
        return self;
    };
}

// .br_ligature(连体符)设置连体属性，0 表示没有连体字符，1 表示使用默认的连体字符
- (NSMutableAttributedString *(^)(NSInteger))br_ligature {
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSLigatureAttributeName value:@(obj)];
        return self;
    };
}

// .br_kern(字间距)，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
- (NSMutableAttributedString *(^)(NSInteger))br_kern {
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSKernAttributeName value:@(obj)];
        return self;
    };
}

//.br_strikethrough(删除线)，NSUnderlineStyle
- (NSMutableAttributedString *(^)(NSUnderlineStyle))br_strikethrough {
    return ^NSMutableAttributedString *(NSUnderlineStyle obj) {
        [self br_addAttribute:NSStrikethroughStyleAttributeName value:@(obj)];
        return self;
    };
}

// NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
- (NSMutableAttributedString *(^)(UIColor *))br_strikethroughColor {
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSStrikethroughStyleAttributeName value:obj];
        return self;
    };
}

// 设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
- (NSMutableAttributedString *(^)(NSUnderlineStyle))br_underlineStyle {
    return ^NSMutableAttributedString *(NSUnderlineStyle obj) {
        [self br_addAttribute:NSUnderlineStyleAttributeName value:@(obj)];
        return self;
    };
}

// NSUnderlineColorAttributeName 设置下划线颜色，取值为 UIColor 对象，默认值为黑色
- (NSMutableAttributedString *(^)(UIColor *))br_underlineColor {
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSUnderlineColorAttributeName value:obj];
        return self;
    };
}

// NSStrokeWidthAttributeName 设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
- (NSMutableAttributedString *(^)(NSInteger))br_strokeWidth {
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSStrokeWidthAttributeName value:@(obj)];
        return self;
    };
}

// NSStrokeColorAttributeName 填充部分颜色，不是字体颜色，取值为 UIColor 对象
- (NSMutableAttributedString *(^)(UIColor *))br_strokeColor {
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSStrokeColorAttributeName value:obj];
        return self;
    };
}

// NSShadowAttributeName 设置阴影属性，取值为 NSShadow 对象
- (NSMutableAttributedString *(^)(NSShadow *))br_shadow {
    return ^NSMutableAttributedString *(NSShadow *obj) {
        [self br_addAttribute:NSShadowAttributeName value:obj];
        return self;
    };
}

// NSTextEffectAttributeName 设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
- (NSMutableAttributedString *(^)(NSString *))br_textEffect {
    return ^NSMutableAttributedString *(NSString *obj) {
        [self br_addAttribute:NSTextEffectAttributeName value:obj];
        return self;
    };
}

// NSObliquenessAttributeName设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
- (NSMutableAttributedString *(^)(CGFloat))br_obliqueness {
    return ^NSMutableAttributedString *(CGFloat obj) {
        [self br_addAttribute:NSObliquenessAttributeName value:@(obj)];
        return self;
    };
}

// NSExpansionAttributeName 设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
- (NSMutableAttributedString *(^)(CGFloat))br_expansion {
    return ^NSMutableAttributedString *(CGFloat obj) {
        [self br_addAttribute:NSExpansionAttributeName value:@(obj)];
        return self;
    };
}

// NSWritingDirectionAttributeName 设置文字书写方向 NSWritingDirection
- (NSMutableAttributedString *(^)(NSWritingDirection))br_writingDirection {
    return ^NSMutableAttributedString *(NSWritingDirection obj) {
        [self br_addAttribute:NSWritingDirectionAttributeName value:@(obj)];
        return self;
    };
}

// NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
- (NSMutableAttributedString *(^)(NSInteger))br_verticalGlyph {
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSVerticalGlyphFormAttributeName value:@(obj)];
        return self;
    };
}

// NSLinkAttributeName 设置链接属性，点击后调用打开指定URL地址
- (NSMutableAttributedString *(^)(NSURL *))br_linkAttribute {
    return ^NSMutableAttributedString *(NSURL *obj) {
        [self br_addAttribute:NSLinkAttributeName value:obj];
        return self;
    };
}

#pragma mark - NSParagraphStyleAttributeName 设置文本段落排版格式
// 对齐
- (NSMutableAttributedString *(^)(NSTextAlignment))br_alignment {
    return ^NSMutableAttributedString *(NSTextAlignment obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.alignment = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 行间距
- (NSMutableAttributedString *(^)(CGFloat))br_lineSpacing {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.lineSpacing = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        
        return self;
    };
}

// 段间距
- (NSMutableAttributedString *(^)(CGFloat))br_paragraphSpacing {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.paragraphSpacing = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 首行缩进
- (NSMutableAttributedString *(^)(CGFloat))br_firstLineHeadIndent {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.firstLineHeadIndent = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 缩进
- (NSMutableAttributedString *(^)(CGFloat))br_headIndent {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.headIndent = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 尾部缩进
- (NSMutableAttributedString *(^)(CGFloat))br_tailIndent {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.tailIndent = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 断行方式
- (NSMutableAttributedString *(^)(NSLineBreakMode))br_lineBreakMode {
    return ^NSMutableAttributedString *(NSLineBreakMode obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.lineBreakMode = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 最大行高
- (NSMutableAttributedString *(^)(CGFloat))br_maximumLineHeight {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.maximumLineHeight = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 最低行高
- (NSMutableAttributedString *(^)(CGFloat))br_minimumLineHeight {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.minimumLineHeight = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 句子方向
- (NSMutableAttributedString *(^)(NSWritingDirection))br_baseWritingDirection {
    return ^NSMutableAttributedString *(NSWritingDirection obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.baseWritingDirection = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 可变行高,乘因数
- (NSMutableAttributedString *(^)(CGFloat))br_lineHeightMultiple {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.lineHeightMultiple = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

// 连字符属性
- (NSMutableAttributedString *(^)(CGFloat))br_hyphenationFactor {
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style = [self br_paragraphStyle];
        style.hyphenationFactor = obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

#pragma mark - ChangeRange 的 get、set
- (void)setChangeRange:(NSRange)changeRange {
    objc_setAssociatedObject(self, @selector(changeRange), [NSNumber valueWithRange:changeRange], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSRange)changeRange {
    NSNumber *rangeNum = objc_getAssociatedObject(self, @selector(changeRange));
    NSRange range = [rangeNum rangeValue];
    return range;
}

// 获取有效的range（当前要修改的文本范围）
- (NSRange)range {
    NSRange range = NSMakeRange(0, 0);
    NSString *string = self.string;
    if (string && string.length > 0) {
        if (self.changeRange.length > 0 && NSMaxRange(self.changeRange) <= string.length) {
            // 如果是需要修改的字符，就使用changeRange
            range = self.changeRange;
        } else {
            // 设置全部字符串
            range = NSMakeRange(0, string.length);
        }
    }
    return range;
}

@end
