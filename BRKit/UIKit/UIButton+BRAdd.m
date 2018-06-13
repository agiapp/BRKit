//
//  UIButton+BRAdd.m
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import "UIButton+BRAdd.h"
#import "BRKitMacro.h"

BRSYNTH_DUMMY_CLASS(UIButton_BRAdd)

@implementation UIButton (BRAdd)

- (void)br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case BRButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space / 2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - space / 2.0, 0);
        }
            break;
        case BRButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space / 2.0, 0, space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, -space / 2.0);
        }
            break;
        case BRButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - space / 2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - space / 2.0, -imageWith, 0, 0);
        }
            break;
        case BRButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space / 2.0, 0, -labelWidth - space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - space / 2.0, 0, imageWith + space / 2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)br_startWithTime:(NSInteger)seconds color:(UIColor *)color countDownColor:(UIColor *)countDownColor {
    __weak typeof(self) weakSelf = self;
    // 倒计时时间
    __block NSInteger timeOut = seconds;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //weakSelf.backgroundColor = color;
                [weakSelf setTitleColor:color forState:UIControlStateNormal];
                [weakSelf setTitle:@"重新发送" forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeOut % 61; // 从60数到1
            NSString * timeStr = [NSString stringWithFormat:@"%d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //weakSelf.backgroundColor = countDownColor;
                [weakSelf setTitleColor:countDownColor forState:UIControlStateNormal];
                [weakSelf setTitle:[NSString stringWithFormat:@"(%@s)重新获取", timeStr] forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
