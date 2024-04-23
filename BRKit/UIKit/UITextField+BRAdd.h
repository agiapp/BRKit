//
//  UITextField+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/11.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (BRAdd)<UITextViewDelegate>
/** 最大输入长度 */
@property (nonatomic, assign) NSInteger br_maxLength;
/** 最多保留两位小数 */
@property (nonatomic, assign) NSInteger br_maxPoint;

/** 输入文本的格式(正则表达式) */
@property (nonatomic, copy) NSString *br_regex;

/** 是否清除空格和换行符 */
@property (nonatomic, assign) BOOL br_clearFormat;

@end
