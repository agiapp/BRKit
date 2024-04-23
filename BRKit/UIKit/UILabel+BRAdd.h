//
//  UILabel+BRAdd.h
//  AFNetworking
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BRAdd)

/**
 *  初始化label
 *
 *  返回值UILabel对象，用来实现链式编程
 */
+ (UILabel *(^)(CGRect frame))br_label;

// 对象方法
- (UILabel *(^)(UIColor *backgroundColor))br_backgroundColor;

- (UILabel *(^)(CGRect frame))br_frame;

- (UILabel *(^)(UIFont *font))br_font;

- (UILabel *(^)(UIColor *textColor))br_textColor;

- (UILabel *(^)(NSString *text))br_text;

/**
 *  长按文本支持复制
 */
@property (nonatomic, assign) BOOL copyable;

@end
