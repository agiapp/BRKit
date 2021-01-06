//
//  UITextField+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/5/11.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UITextField+BRAdd.h"
#import <objc/runtime.h>
#import "NSString+BRAdd.h"

/*! runtime set */
#define BR_Objc_setObject(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
/*! runtime setCopy */
#define BR_Objc_setObjectCOPY(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY)
/*! runtime get */
#define BR_Objc_getObject objc_getAssociatedObject(self, _cmd)

@implementation UITextField (BRAdd)

- (void)setBr_maxLength:(NSInteger)br_maxLength {
    BR_Objc_setObject(@selector(br_maxLength), @(br_maxLength));
    [self addTarget:self action:@selector(handleTextFieldTextDidChangeAction) forControlEvents:UIControlEventEditingChanged];
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

- (void)setBr_maxPoint:(NSInteger)br_maxPoint {
    // ^.{m,n}$ 表示至少m个字符，最多n个字符
    //NSString *regex = [NSString stringWithFormat:@"^.{0,%@}$", @(br_maxLength)];
    NSString *regex = [NSString stringWithFormat:@"^\\-?([1-9]\\d*|0)(\\.\\d{0,%@})?$", @(br_maxPoint)];
    [self setBr_regex:regex];
}

- (void)setBr_regex:(NSString *)br_regex {
    BR_Objc_setObjectCOPY(@selector(br_regex), br_regex);
    self.delegate = self;
}

- (NSInteger)br_regex {
    return BR_Objc_getObject;
}

#pragma mark - 限制输入框输入格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.br_regex br_isValidString]) {
        // 即将键入或者粘贴的string
        if (!string.length) {
            return YES;
        }
        NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        // 检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
        return [textString br_checkStringWithRegex:self.br_regex];
    }
    return YES;
}

@end
