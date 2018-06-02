//
//  UIImageView+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (BRAdd)

/** 使用 CAShapeLayer 和 UIBezierPath 设置圆角 */
- (void)br_setBezierPathCornerRadius:(CGFloat)radius;

/** 通过 Graphics 和 BezierPath 设置圆角（推荐用这个）*/
- (void)br_setGraphicsCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
