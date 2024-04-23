//
//  UITextView+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/5/11.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import "UITextView+BRAdd.h"
#import "BRKitMacro.h"
#import "NSString+BRAdd.h"
#import "UIColor+BRAdd.h"
#import <objc/runtime.h>

/*! runtime set */
#define BR_Objc_setObject(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
/*! runtime setCopy */
#define BR_Objc_setObjectCOPY(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY)
/*! runtime get */
#define BR_Objc_getObject objc_getAssociatedObject(self, _cmd)

BRSYNTH_DUMMY_CLASS(UITextView_BRAdd)

@implementation UITextView (BRAdd)

- (void)setBr_maxLength:(NSInteger)br_maxLength {
    BR_Objc_setObject(@selector(br_maxLength), @(br_maxLength));
    //[self addTarget:self action:@selector(handleTextFieldTextDidChangeAction) forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)br_maxLength {
    return [BR_Objc_getObject integerValue];
}

- (void)handleTextFieldTextDidChangeAction {
    NSString *toBeginString = self.text;
    // 获取高亮部分
    UITextRange *selectRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制；在 iOS7 下, position 对象总是不为 nil
    if ((!position || !selectRange) && (self.br_maxLength > 0 && toBeginString.length > self.br_maxLength && [self isFirstResponder])) {
        NSRange rangeIndex = [toBeginString rangeOfComposedCharacterSequenceAtIndex:self.br_maxLength];
        if (rangeIndex.length == 1) {
            self.text = [toBeginString substringToIndex:self.br_maxLength];
        } else {
            NSRange tempRange = [toBeginString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.br_maxLength)];
            NSInteger tempLength = 0;
            if (tempRange.length > self.br_maxLength) {
                tempLength = tempRange.length - rangeIndex.length;
            } else {
                tempLength = tempRange.length;
            }
            self.text = [toBeginString substringWithRange:NSMakeRange(0, tempLength)];
        }
    }
}

@end
