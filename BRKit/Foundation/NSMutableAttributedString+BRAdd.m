//
//  NSMutableAttributedString+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSMutableAttributedString+BRAdd.h"
#import <objc/runtime.h>

@interface NSMutableAttributedString ()
@property(nonatomic, assign) NSRange changeRange;

@end

@implementation NSMutableAttributedString (BRAdd)

+ (NSMutableAttributedString *(^)(NSString *text))br_attributedString {
    // 声明并实现一个block，并返回
    return ^(NSString *text) {
        return [[NSMutableAttributedString alloc] initWithString:text];
    };
}

/**
 改变某些文字的颜色 并单独设置其字体
 @param subStrings 想要变色的字符数组
 @param block   里面用make.各种想要的设置
 */
- (void)br_changeSubStrings:(NSArray *)subStrings makeCalculators:(void (^)(NSMutableAttributedString * make))block{
    for (NSString *rangeStr in subStrings) {
        
        NSMutableArray *array = [self br_getRangeWithTotalString:self.string SubString:rangeStr];
        for (NSNumber *rangeNum in array) {
            //设置修改range
            self.changeRange = [rangeNum rangeValue];
            //block 链式调用
            block(self);
        }
    }
    //设置为空
    self.changeRange=NSMakeRange(0, 0);
}

/**
 多个AttributedString连接
 */
- (void)br_appendAttributedStrings:(NSArray *)attrStrings{
    
    for (NSAttributedString *att in attrStrings) {
        
        [self appendAttributedString:att];
    }
}
/**
 多个AttributedString连接
 */
+ (NSMutableAttributedString *)br_appendAttributedStrings:(NSArray *)attrStrings{
    
    NSMutableAttributedString *att=[NSMutableAttributedString new];
    [att br_appendAttributedStrings:attrStrings];
    return att;
    
}

#pragma mark - Private Methods
/**
 *  获取某个字符串中子字符串的位置数组
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *  @return 位置数组
 */
- (NSMutableArray *)br_getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString {
    if (subString == nil && [subString isEqualToString:@""]) {
        return nil;
    }
    NSMutableArray *arrayRanges = [NSMutableArray array];
    
    // 方法一、NSRegularExpression
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:subString options:0 error:nil];
    NSArray *matches = [regex matchesInString:totalString options:0 range:NSMakeRange(0, totalString.length)];
    
    for(NSTextCheckingResult *result in [matches objectEnumerator]){
        NSRange matchRange = [result range];
        [arrayRanges addObject:[NSNumber valueWithRange:matchRange]];
    }
    return arrayRanges;
    
    // 方法二、[NSString componentsSeparatedByString:]分解得到数组，在用数组捣鼓出ranges
    /*
         NSArray *array=[totalString componentsSeparatedByString:subString];
         NSInteger d=0;
         for (int i=0; i<array.count-1; i++) {
         
         NSString *string=array[i];
         NSRange range=NSMakeRange(d+string.length, subString.length);
         d=NSMaxRange(range);
         [arrayRanges addObject:[NSNumber valueWithRange:range]];
         
         }
         return arrayRanges;
     */
    
    // 方法三、rangeOfString 查找
    /*
         NSRange searchRange = NSMakeRange(0, [totalString length]);
         NSRange range=NSMakeRange(0, 0);
         while ((range = [totalString rangeOfString:subString options:0 range:searchRange]).location != NSNotFound) {
         [arrayRanges addObject:[NSNumber valueWithRange:range]];
         searchRange = NSMakeRange(NSMaxRange(range), searchRange.length - NSMaxRange(range));
         }
         return arrayRanges;
     */
}

- (void)br_addAttribute:(NSString *)name value:(id)value {
    NSRange range = [self range];
    if (range.length > 0) {
        [self addAttribute:name value:value range:range];
    } else {
        NSLog(@"AttributedString的string为空，注意!!!");
    }
}

// 获取有效的range
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

- (NSMutableParagraphStyle *)br_paragraphStyle {
    NSRange range = [self range];
    if (range.length > 0) {
        NSDictionary *dic = [self attributesAtIndex:0 effectiveRange:&range];
        NSMutableParagraphStyle *paragraphStyle=dic[@"NSParagraphStyle"];
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

#pragma mark - ChangeRange 的 get、set
- (void)setChangeRange:(NSRange)changeRange {
    objc_setAssociatedObject(self, @selector(changeRange), [NSNumber valueWithRange:changeRange], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSRange)changeRange {
    NSNumber *rangeNum = objc_getAssociatedObject(self, @selector(changeRange));
    NSRange range = [rangeNum rangeValue];
    return range;
}

#pragma mark - 设置各种配置参数
// 颜色
- (NSMutableAttributedString *(^)(UIColor *))br_color {
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSForegroundColorAttributeName value:obj];
        return self;
    };
}

/**
 .br_bgColor(背景颜色)
 */
- (NSMutableAttributedString *(^)(UIColor *))br_bgColor {
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSBackgroundColorAttributeName value:obj];
        return self;
    };
}

// 字体
- (NSMutableAttributedString *(^)(UIFont *))br_font {
    return ^NSMutableAttributedString *(UIFont *obj) {
        [self br_addAttribute:NSFontAttributeName value:obj];
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

//.br_ligature(连体符)设置连体属性，0 表示没有连体字符，1 表示使用默认的连体字符
- (NSMutableAttributedString *(^)(NSInteger))br_ligature {
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSLigatureAttributeName value:@(obj)];
        return self;
    };
}

//.br_kern(字间距)，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
- (NSMutableAttributedString *(^)(NSInteger))br_kern{
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSKernAttributeName value:@(obj)];
        return self;
    };
}

//.br_strikethrough(删除线)，NSUnderlineStyle
- (NSMutableAttributedString *(^)(NSUnderlineStyle))br_strikethrough{
    return ^NSMutableAttributedString *(NSUnderlineStyle obj) {
        [self br_addAttribute:NSStrikethroughStyleAttributeName value:@(obj)];
        return self;
    };
}

//NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
- (NSMutableAttributedString *(^)(UIColor *))br_strikethroughColor{
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSStrikethroughStyleAttributeName value:obj];
        return self;
    };
}

//设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
- (NSMutableAttributedString *(^)(NSUnderlineStyle))br_underlineStyle{
    return ^NSMutableAttributedString *(NSUnderlineStyle obj) {
        [self br_addAttribute:NSUnderlineStyleAttributeName value:@(obj)];
        return self;
    };
}

//NSUnderlineColorAttributeName 设置下划线颜色，取值为 UIColor 对象，默认值为黑色
- (NSMutableAttributedString *(^)(UIColor *))br_underlineColor{
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSUnderlineColorAttributeName value:obj];
        return self;
    };
}

//NSStrokeWidthAttributeName 设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
- (NSMutableAttributedString *(^)(NSInteger))br_strokeWidth{
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSStrokeWidthAttributeName value:@(obj)];
        return self;
    };
}

//NSStrokeColorAttributeName 填充部分颜色，不是字体颜色，取值为 UIColor 对象
- (NSMutableAttributedString *(^)(UIColor *))br_strokeColor{
    return ^NSMutableAttributedString *(UIColor *obj) {
        [self br_addAttribute:NSStrokeColorAttributeName value:obj];
        return self;
    };
}

//NSShadowAttributeName 设置阴影属性，取值为 NSShadow 对象
- (NSMutableAttributedString *(^)(NSShadow *))br_shadow{
    return ^NSMutableAttributedString *(NSShadow *obj) {
        [self br_addAttribute:NSShadowAttributeName value:obj];
        return self;
    };
}

//NSTextEffectAttributeName 设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
- (NSMutableAttributedString *(^)(NSString *))br_textEffect{
    return ^NSMutableAttributedString *(NSString *obj) {
        [self br_addAttribute:NSTextEffectAttributeName value:obj];
        return self;
    };
}

//NSObliquenessAttributeName设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
- (NSMutableAttributedString *(^)(CGFloat))br_obliqueness{
    return ^NSMutableAttributedString *(CGFloat obj) {
        [self br_addAttribute:NSObliquenessAttributeName value:@(obj)];
        return self;
    };
}

//NSExpansionAttributeName 设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
- (NSMutableAttributedString *(^)(CGFloat))br_expansion{
    return ^NSMutableAttributedString *(CGFloat obj) {
        [self br_addAttribute:NSExpansionAttributeName value:@(obj)];
        return self;
    };
}

//NSWritingDirectionAttributeName 设置文字书写方向NSWritingDirection
- (NSMutableAttributedString *(^)(NSWritingDirection))br_writingDirection{
    return ^NSMutableAttributedString *(NSWritingDirection obj) {
        [self br_addAttribute:NSWritingDirectionAttributeName value:@(obj)];
        return self;
    };
}

//NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
- (NSMutableAttributedString *(^)(NSInteger))br_verticalGlyph{
    return ^NSMutableAttributedString *(NSInteger obj) {
        [self br_addAttribute:NSVerticalGlyphFormAttributeName value:@(obj)];
        return self;
    };
}

//NSLinkAttributeName 设置链接属性，点击后调用打开指定URL地址
- (NSMutableAttributedString *(^)(NSURL *))br_linkAttribute{
    return ^NSMutableAttributedString *(NSURL *obj) {
        [self br_addAttribute:NSLinkAttributeName value:obj];
        return self;
    };
}

#pragma mark -NSParagraphStyleAttributeName 设置文本段落排版格式
//对齐
- (NSMutableAttributedString *(^)(NSTextAlignment))br_alignment{
    return ^NSMutableAttributedString *(NSTextAlignment obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.alignment=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//行间距
- (NSMutableAttributedString *(^)(CGFloat ))br_lineSpacing{
    return ^NSMutableAttributedString *(CGFloat obj) {
        
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.lineSpacing=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        
        return self;
    };
}

//段间距
- (NSMutableAttributedString *(^)(CGFloat ))br_paragraphSpacing{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.paragraphSpacing=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//首行缩进
- (NSMutableAttributedString *(^)(CGFloat ))br_firstLineHeadIndent{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.firstLineHeadIndent=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//缩进
- (NSMutableAttributedString *(^)(CGFloat ))br_headIndent{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.headIndent=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//尾部缩进
- (NSMutableAttributedString *(^)(CGFloat ))br_tailIndent{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.tailIndent=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//断行方式
- (NSMutableAttributedString *(^)(NSLineBreakMode ))br_lineBreakMode{
    return ^NSMutableAttributedString *(NSLineBreakMode obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.lineBreakMode=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//最大行高
- (NSMutableAttributedString *(^)(CGFloat ))br_maximumLineHeight{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.maximumLineHeight=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//最低行高
- (NSMutableAttributedString *(^)(CGFloat ))br_minimumLineHeight{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.minimumLineHeight=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//句子方向
- (NSMutableAttributedString *(^)(NSWritingDirection ))br_baseWritingDirection{
    return ^NSMutableAttributedString *(NSWritingDirection obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.baseWritingDirection=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//可变行高,乘因数
- (NSMutableAttributedString *(^)(CGFloat ))br_lineHeightMultiple{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.lineHeightMultiple=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

//连字符属性
- (NSMutableAttributedString *(^)(CGFloat ))br_hyphenationFactor{
    return ^NSMutableAttributedString *(CGFloat obj) {
        NSMutableParagraphStyle *style=[self br_paragraphStyle];
        style.hyphenationFactor=obj;
        [self br_addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

@end
