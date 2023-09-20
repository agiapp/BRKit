//
//  NSMutableAttributedString+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
    使用例子：
 
    NSString *text = @"这是一段富文本，<em>测试</em>文本。Hello Word!";
    // 创建 attributedString
    //NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableAttributedString *attributedString = NSMutableAttributedString.br_attributedString(text);
 
    // 设置全部字符串样式（链式写法1）
    attributedString.br_color([UIColor blackColor]).br_font([UIFont systemFontOfSize:16]).br_lineSpacing(5);
    // 设置全部字符串样式（链式写法2）
    [attributedString br_makeCalculators:^(NSMutableAttributedString *make) {
        make.br_color([UIColor blackColor]);
        make.br_font([UIFont systemFontOfSize:16]);
        make.br_lineBreakMode(NSLineBreakByWordWrapping);
        make.br_alignment(NSTextAlignmentCenter);
        make.br_lineSpacing(5);
        make.br_emTagString([UIColor redColor]); // <em>标签内文本标红显示
    }];
 
    // 设置指定字符串样式
    [attributedString br_changeSubStrings:@[@"Hello"] makeCalculators:^(NSMutableAttributedString *make) {
        make.br_color([UIColor orangeColor]).br_font([UIFont systemFontOfSize:16]);
    }];
 
    // 设置<em>标签内文本样式
    [attributedString br_changeTagString:@"em" makeCalculators:^(NSMutableAttributedString *make) {
        make.br_color([UIColor redColor]);
        make.br_font([UIFont systemFontOfSize:22]);
    }];
 
    label.attributedText = attributedString;
 
 */

@interface NSMutableAttributedString (BRAdd)

/**
 *  初始化 NSMutableAttributedString
 *
 *  返回值 NSMutableAttributedString 对象，用来实现链式编程
 */
+ (NSMutableAttributedString *(^)(NSString *text))br_attributedString;

/**
 *  设置字符串的样式
 *  @param  block       里面用make.各种想要的设置
 */
- (void)br_makeCalculators:(void (^)(NSMutableAttributedString *make))block;

/**
 *  设置子字符串的样式
 *  @param  subString   子字符串数
 *  @param  block       里面用make.各种想要的设置
 */
- (void)br_changeSubString:(NSString *)subString makeCalculators:(void (^)(NSMutableAttributedString *make))block;

/**
 *  设置多个子字符串的样式
 *  @param  subStrings  子字符串数组
 *  @param  block       里面用make.各种想要的设置
 */
- (void)br_changeSubStrings:(NSArray *)subStrings makeCalculators:(void (^)(NSMutableAttributedString *make))block;

/**
 *  设置标签内字符串的样式
 *  @param  tagString  标签字符串（如：em，表示设置<em></em>标签内字符串的样式）
 *  @param  block   里面用make.各种想要的设置
 */
- (void)br_changeTagString:(NSString *)tagString makeCalculators:(void (^)(NSMutableAttributedString *make))block;

/**
 *  <em>标签内字符串标记颜色显示（一般用于搜索结果展示）
 *  如：@"美国<em>苹果</em>公司"，@"苹果"关键词标红显示
 */
- (NSMutableAttributedString *(^)(UIColor *))br_emTagString;

/**
 多个AttributedString连接
 */
- (void)br_appendAttributedStrings:(NSArray *)attrStrings;

/**
 多个AttributedString连接
 */
+ (NSMutableAttributedString *)br_appendAttributedStrings:(NSArray *)attrStrings;


#pragma mark - 基本设置
// NSFontAttributeName                  设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
// NSForegroundColorAttributeNam        设置字体颜色，取值为 UIColor对象，默认值为黑色
// NSBackgroundColorAttributeName       设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
// NSLigatureAttributeName              设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
// NSKernAttributeName                  设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
// NSStrikethroughStyleAttributeName    设置删除线，取值为 NSNumber 对象（整数）
// NSStrikethroughColorAttributeName    设置删除线颜色，取值为 UIColor 对象，默认值为黑色
// NSUnderlineStyleAttributeName        设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
// NSUnderlineColorAttributeName        设置下划线颜色，取值为 UIColor 对象，默认值为黑色
// NSStrokeWidthAttributeName           设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
// NSStrokeColorAttributeName           填充部分颜色，不是字体颜色，取值为 UIColor 对象
// NSShadowAttributeName                设置阴影属性，取值为 NSShadow 对象
// NSTextEffectAttributeName            设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
// NSBaselineOffsetAttributeName        设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
// NSObliquenessAttributeName           设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
// NSExpansionAttributeName             设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
// NSWritingDirectionAttributeName      设置文字书写方向，从左向右书写或者从右向左书写
// NSVerticalGlyphFormAttributeName     设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
// NSLinkAttributeName                  设置链接属性，点击后调用打开指定URL地址
// NSAttachmentAttributeName            设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排

/**
 .color(文字颜色)
 */
- (NSMutableAttributedString *(^)(UIColor *))br_color;

/**
 .br_colorRange(颜色, 文本范围)
 */
- (NSMutableAttributedString *(^)(UIColor *, NSRange))br_colorRange;

/**
 .br_bgColor(背景颜色)
 */
- (NSMutableAttributedString *(^)(UIColor *))br_bgColor;

/**
 .font(字体)
 */
- (NSMutableAttributedString *(^)(UIFont *))br_font;

/**
 .br_fontRange(字体, 文本范围)
 */
- (NSMutableAttributedString *(^)(UIFont *, NSRange))br_fontRange;

/**
 .br_offset(偏移量) 正值上偏，负值下偏
 */
- (NSMutableAttributedString *(^)(CGFloat))br_baselineOffset;

/**
 .br_ligature(连体符)设置连体属性，0 表示没有连体字符，1 表示使用默认的连体字符
 */
- (NSMutableAttributedString *(^)(NSInteger))br_ligature;

/**
 .br_kern(字间距)，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 */
- (NSMutableAttributedString *(^)(NSInteger))br_kern;

/**
 .br_strikethrough(删除线)，取值为 NSNumber 对象（整数）
 */
- (NSMutableAttributedString *(^)(NSUnderlineStyle))br_strikethrough;

/**
 NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 */
- (NSMutableAttributedString *(^)(UIColor *))br_strikethroughColor;

/**
 设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 */
- (NSMutableAttributedString *(^)(NSUnderlineStyle))br_underlineStyle;

/**
 NSUnderlineColorAttributeName 设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 */
- (NSMutableAttributedString *(^)(UIColor *))br_underlineColor;

/**
 NSStrokeWidthAttributeName 设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 */
- (NSMutableAttributedString *(^)(NSInteger))br_strokeWidth;

/**
 NSStrokeColorAttributeName 填充部分颜色，不是字体颜色，取值为 UIColor 对象
 */
- (NSMutableAttributedString *(^)(UIColor *))br_strokeColor;

/**
 NSShadowAttributeName 设置阴影属性，取值为 NSShadow 对象
 */
- (NSMutableAttributedString *(^)(NSShadow *))br_shadow;

/**
 NSTextEffectAttributeName 设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 */
- (NSMutableAttributedString *(^)(NSString *))br_textEffect;

/**
 NSObliquenessAttributeName设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 */
- (NSMutableAttributedString *(^)(CGFloat))br_obliqueness;

/**
 NSExpansionAttributeName 设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 */
- (NSMutableAttributedString *(^)(CGFloat))br_expansion;

/**
 NSWritingDirectionAttributeName 设置文字书写方向NSWritingDirection
 */
- (NSMutableAttributedString *(^)(NSWritingDirection))br_writingDirection;

/**
 NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 */
- (NSMutableAttributedString *(^)(NSInteger))br_verticalGlyph;

/**
 NSLinkAttributeName 设置链接属性，点击后调用打开指定URL地址
 */
- (NSMutableAttributedString *(^)(NSURL *))br_linkAttribute;


#pragma mark - NSParagraphStyleAttributeName 设置文本段落排版格式
// alignment                //对齐方式
// lineSpacing              //行距
// paragraphSpacing         //段距
// firstLineHeadIndent      //首行缩进
// headIndent               //缩进
// tailIndent               //尾部缩进
// lineBreakMode            //断行方式
// maximumLineHeight        //最大行高
// minimumLineHeight        //最低行高
// paragraphSpacingBefore   //段首空间
// baseWritingDirection     //句子方向
// lineHeightMultiple       //可变行高,乘因数。
// hyphenationFactor        //连字符属性

/**
 .alignment(对齐)
 */
- (NSMutableAttributedString *(^)(NSTextAlignment))br_alignment;

/**
 .lineSpacing(调整行间距)
 */
- (NSMutableAttributedString *(^)(CGFloat))br_lineSpacing;

/**
 .paragraphSpacing(调整段间距)
 */
- (NSMutableAttributedString *(^)(CGFloat))br_paragraphSpacing;

/**
 首行缩进
 */
- (NSMutableAttributedString *(^)(CGFloat))br_firstLineHeadIndent;

/**
 缩进
 */
- (NSMutableAttributedString *(^)(CGFloat))br_headIndent;

/**
 尾部缩进
 */
- (NSMutableAttributedString *(^)(CGFloat))br_tailIndent;

/**
 断行方式
 */
- (NSMutableAttributedString *(^)(NSLineBreakMode))br_lineBreakMode;

/**
 最大行高
 */
- (NSMutableAttributedString *(^)(CGFloat))br_maximumLineHeight;

/**
 最低行高
 */
- (NSMutableAttributedString *(^)(CGFloat))br_minimumLineHeight;

/**
 句子方向
 */
- (NSMutableAttributedString *(^)(NSWritingDirection))br_baseWritingDirection;

/**
 可变行高,乘因数
 */
- (NSMutableAttributedString *(^)(CGFloat))br_lineHeightMultiple;

/**
 连字符属性
 */
- (NSMutableAttributedString *(^)(CGFloat))br_hyphenationFactor;

@end
