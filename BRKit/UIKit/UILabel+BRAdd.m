//
//  UILabel+BRAdd.m
//  AFNetworking
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UILabel+BRAdd.h"
#import <objc/runtime.h>

@implementation UILabel (BRAdd)

+ (UILabel * _Nonnull (^)(CGRect))br_label {
    // 声明并实现一个block，并返回
    return ^(CGRect frame) {
        // 根据传过来的frame参数初始化UILabel，并返回
        return [[UILabel alloc] initWithFrame:frame];
    };
}

- (UILabel * _Nonnull (^)(UIColor * _Nonnull))br_backgroundColor {
    return ^(UIColor *backgroundColor) {
        self.backgroundColor = backgroundColor;
        return self;
    };
}

- (UILabel * _Nonnull (^)(CGRect))br_frame {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UILabel * _Nonnull (^)(UIFont * _Nonnull))br_font {
    return ^(UIFont *font) {
        self.font = font;
        return self;
    };
}

- (UILabel * _Nonnull (^)(UIColor * _Nonnull))br_textColor {
    return ^(UIColor *textColor) {
        self.textColor = textColor;
        return self;
    };
}

- (UILabel * _Nonnull (^)(NSString * _Nonnull))br_text {
    return ^(NSString *text) {
        self.text = text;
        return self;
    };
}

#pragma mark - ------------ 长按文本支持复制 -----------
- (BOOL)copyable {
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}

- (void)setCopyable:(BOOL)copyable {
    objc_setAssociatedObject(self, @selector(copyable), [NSNumber numberWithBool:copyable], OBJC_ASSOCIATION_ASSIGN);
    [self addLongPressGestureRecognizer];
}

#pragma mark - 添加长按手势和菜单消失的通知
- (void)addLongPressGestureRecognizer {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongTapLabel:)];
    [self addGestureRecognizer:longPress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide) name:UIMenuControllerWillHideMenuNotification object:nil];
}

#pragma mark 长按手势处理
- (void)didLongTapLabel:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyItem]];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        self.backgroundColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.2f];
    }
}

#pragma mark 菜单消失 处理界面
- (void)menuControllerWillHide {
    [self resignFirstResponder];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark 使Label能成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}

#pragma mark 指定Label可以响应的方法（这里只用到复制）
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction)) {
        return YES;
    }
    return NO;
}

#pragma mark 点击复制按钮后的处理
- (void)copyAction {
    [self resignFirstResponder];
    
    // UIPasteboard 的string只能接受 NSString 类型，当Label设置的是attributedText时需要进行转换
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    if (self.text) {
        pastboard.string = self.text;
    }else{
        pastboard.string = self.attributedText.string;
    }
    
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark
- (void)dealloc {
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

@end
