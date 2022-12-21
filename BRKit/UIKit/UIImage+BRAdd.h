//
//  UIImage+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BRAdd)
/** 显示原图（避免被系统渲染成蓝色） */
+ (nullable UIImage *)br_originalImage:(NSString *)imageName;
/** 用颜色返回一张图片 */
+ (nullable UIImage *)br_imageWithColor:(UIColor *)color;
/** 用颜色返回一张图片（指定图片大小） */
+ (nullable UIImage *)br_imageWithColor:(UIColor *)color size:(CGSize)size;
/** UIView 转 UIImage */
+ (nullable UIImage *)br_imageWithView:(UIView *)view;
/** 为UIImage添加滤镜效果 */
- (nullable UIImage *)br_addFilter:(NSString *)filter;
/** 设置图片的透明度 */
- (nullable UIImage *)br_alpha:(CGFloat)alpha;
/**
 *  设置圆角图片
 *
 *  @param radius 圆角半径
 */
- (nullable UIImage *)br_imageByRoundCornerRadius:(CGFloat)radius;

/**
 *  设置圆角图片
 *
 *  @param radius 圆角半径
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
- (nullable UIImage *)br_imageByRoundCornerRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor;

/** 截取当前屏幕的截图/快照 */
+ (nullable UIImage *)br_imageWithScreenshot;

/// 局部截图：截取指定视图指定大小
/// @param view 截取的指定视图
/// @param size 截取的指定大小
+ (nullable UIImage *)br_screenShotWithView:(UIView *)view size:(CGSize)size;

/// 截取长图(即截取 tableView、collectionView)
/// @param srcollView 截取的滚动视图(长图)
+ (nullable UIImage *)br_screenShotWithSrollView:(UIScrollView *)srcollView;

/// 图片拼接(拼接头部/尾部视图)
/// @param headImage 头图片
/// @param footImage 尾图片
- (nullable UIImage *)br_addHeadImage:(nullable UIImage *)headImage footImage:(nullable UIImage *)footImage;

/// 压缩图片（使图片压缩后刚好小于指定大小）
/// @param maxLength 图片压缩后的最大大小
- (nullable NSData *)br_compressImageWithMaxLength:(NSUInteger)maxLength;

/**
 * 压缩图片（使图片压缩后刚好小于指定大小，单位：KB）
 * 保证图片清晰度，结合图片质量和大小进行压缩（最大长度128KB。传值，如：maxLength = 128 * 1024）
 */
+ (UIImage *)br_compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

/** 图片 转 base64字符串 */
+ (NSString *)br_base64StringWithImage:(UIImage *)image;

/** base64字符串 转 图片 */
+ (UIImage *)br_imageWithBase64String:(NSString *)base64String;

@end

NS_ASSUME_NONNULL_END
