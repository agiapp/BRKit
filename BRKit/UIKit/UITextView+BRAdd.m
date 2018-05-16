//
//  UITextView+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/5/11.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UITextView+BRAdd.h"
#import "BRKitMacro.h"
#import <objc/runtime.h>

BRSYNTH_DUMMY_CLASS(UITextView_BRAdd)

const char *kTextViewInputLimitKey = "kTextViewInputLimit";

@implementation UITextView (BRAdd)

+ (void)load {
    // 添加监听(监听文本的变化)
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - 通知事件
- (void)textViewTextDidChange:(NSNotification *)notification {
    UITextView *textView = (UITextView *)notification.object;
    if (self.inputLimit > 0 && textView.text.length > self.inputLimit && textView.markedTextRange == nil) {
        textView.text = [textView.text substringFromIndex:self.inputLimit - 1];
    }
}

#pragma mark - setter方法
- (void)setInputLimit:(NSInteger)inputLimit {
    objc_setAssociatedObject(self, kTextViewInputLimitKey, @(inputLimit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter方法
- (NSInteger)inputLimit {
    NSNumber *limit = objc_getAssociatedObject(self, kTextViewInputLimitKey);
    return [limit integerValue];
}

@end
