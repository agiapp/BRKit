//
//  NSTimer+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "NSTimer+BRAdd.h"
#import "BRKitMacro.h"

BRSYNTH_DUMMY_CLASS(NSTimer_BRAdd)

@implementation NSTimer (BRAdd)

+ (void)br_executeBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)br_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(br_executeBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)br_timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(br_executeBlock:) userInfo:[block copy] repeats:repeats];
}

@end
