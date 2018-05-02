//
//  UIButton+BRAdd.h
//  BRKitDemo
//
//  Created by 任波 on 2018/5/2.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BRButtonEdgeInsetsStyle) {
    /** image在上，label在下 */
    BRButtonEdgeInsetsStyleTop,
    /** image在左，label在右 */
    BRButtonEdgeInsetsStyleLeft,
    /** image在下，label在上 */
    BRButtonEdgeInsetsStyleBottom,
    /** image在右，label在左 */
    BRButtonEdgeInsetsStyleRight
};

@interface UIButton (BRAdd)

/**
 *  设置button的文字和图片的布局样式，及间距
 *
 *  @param style 文字和图片的布局样式
 *  @param space 文字和图片的间距
 */
- (void)br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
