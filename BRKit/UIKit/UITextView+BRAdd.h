//
//  UITextView+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/11.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (BRAdd)<UITextViewDelegate>
/** 最大输入长度 */
@property (nonatomic, assign) NSInteger br_maxLength;

@end
