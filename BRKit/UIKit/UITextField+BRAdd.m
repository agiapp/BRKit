//
//  UITextField+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/5/11.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UITextField+BRAdd.h"
#import "BRKitMacro.h"
#import <objc/runtime.h>

BRSYNTH_DUMMY_CLASS(UITextField_BRAdd)

const char *kTextFieldInputLimitKey = "kTextFieldInputLimit";

@implementation UITextField (BRAdd)

+ (void)load {
    // 添加监听(监听文本的变化)
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 通知事件
- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (self.inputLimit > 0 && textField.text.length > self.inputLimit && textField.markedTextRange == nil) {
        textField.text = [textField.text substringFromIndex:self.inputLimit - 1];
    }
}

#pragma mark - setter方法
- (void)setInputLimit:(NSInteger)inputLimit {
    objc_setAssociatedObject(self, kTextFieldInputLimitKey, @(inputLimit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter方法
- (NSInteger)inputLimit {
    NSNumber *limit = objc_getAssociatedObject(self, kTextFieldInputLimitKey);
    return [limit integerValue];
}

@end
