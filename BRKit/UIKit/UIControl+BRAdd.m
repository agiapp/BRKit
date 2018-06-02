//
//  UIControl+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/5/17.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UIControl+BRAdd.h"
#import "BRKitMacro.h"
#import <objc/runtime.h>

BRSYNTH_DUMMY_CLASS(UIControl_BRAdd)

static const char *UIControl_acceptEventInterval="UIControl_acceptEventInterval";
static const char *UIControl_ignoreEvent="UIControl_ignoreEvent";

@implementation UIControl (BRAdd)
#pragma mark - Swizzling
+ (void)load {
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(swizzled_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);//交换方法
}

- (void)swizzled_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ignoreEvent) {
        NSLog(@"btnAction is intercepted");
        return;
    }
    if (self.acceptEventInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreEventWithNo) withObject:nil afterDelay:self.acceptEventInterval];
    }
    // 调用系统的 sendAction:to:forEvent: 方法
    [self swizzled_sendAction:action to:target forEvent:event];
}

- (void)setIgnoreEventWithNo {
    self.ignoreEvent = NO;
}

#pragma mark - setter方法
- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - getter方法
- (NSTimeInterval)acceptEventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

@end
