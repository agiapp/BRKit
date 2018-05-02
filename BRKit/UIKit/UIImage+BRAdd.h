//
//  UIImage+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BRAdd)

/** 用颜色返回一张图片 */
+ (UIImage *)br_imageWithColor:(UIColor *)color;
/** 为UIImage添加滤镜效果 */
- (UIImage *)br_addFilter:(NSString *)filter;
/** 设置图片的透明度 */
- (UIImage *)br_setAlpha:(CGFloat)alpha;

@end
