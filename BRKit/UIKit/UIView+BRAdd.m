//
//  UIView+BRAdd.m
//  BRKitDemo
//
//  Created by renbo on 2018/5/2.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import "UIView+BRAdd.h"
#import "BRKitMacro.h"

BRSYNTH_DUMMY_CLASS(UIView_BRAdd)

@implementation UIView (BRAdd)
/// frame 快捷访问
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - 设置视图view的部分圆角(绝对布局)
// corners(枚举类型，可组合使用)：UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
- (void)br_setRoundedCorners:(UIRectCorner)corners
                withRadius:(CGSize)radius {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radius];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

#pragma mark - 设置视图view的部分圆角(相对布局)
// corners(枚举类型，可组合使用)：UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
- (void)br_setRoundedCorners:(UIRectCorner)corners
                withRadius:(CGSize)radius
                 viewRect:(CGRect)rect {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radius];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

#pragma mark - 设置视图view的阴影效果
- (void)br_setLayerShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - 删除所有子视图
- (void)br_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

#pragma mark - 返回当前视图的控制器
- (UIViewController *)br_getViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 创建屏幕快照
- (UIImage *)br_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

#pragma mark - 创建屏幕快照pdf
- (NSData *)br_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

#pragma mark - 设置view的渐变色
- (void)br_setGradientColor:(UIColor *)fromColor toColor:(UIColor *)toColor direction:(BRDirectionType)direction {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor, (__bridge id)toColor.CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    if (direction == BRDirectionTypeTopToBottom) {
        gradientLayer.endPoint = CGPointMake(0, 1.0);
    } else {
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];
}

#pragma mark - 设置view的边框线
- (void)br_setBorderType:(BRBorderSideType)borderType borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    if (borderType == BRBorderSideTypeAll) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.CGColor;
    }
    /// 左侧
    if (borderType & BRBorderSideTypeLeft) {
        /// 左侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, self.frame.size.height) color:borderColor borderWidth:borderWidth]];
    }
    
    /// 右侧
    if (borderType & BRBorderSideTypeRight) {
        /// 右侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(self.frame.size.width, 0.0f) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:borderColor borderWidth:borderWidth]];
    }
    
    /// top
    if (borderType & BRBorderSideTypeTop) {
        /// top线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(self.frame.size.width, 0.0f) color:borderColor borderWidth:borderWidth]];
    }
    
    /// bottom
    if (borderType & BRBorderSideTypeBottom) {
        /// bottom线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, self.frame.size.height) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:borderColor borderWidth:borderWidth]];
    }
}

- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    return shapeLayer;
}

/**
 *  给视图画条虚线
 *
 *  @param point        起点
 *  @param color        虚线颜色
 *  @param width        虚线的宽度
 *  @param length       虚线的长度
 *  @param space        虚线之间的间距
 *  @param size         width 为 0 时垂直；height 为 0 时水平
 */
- (void)br_drawDottedLineWithStartPoint:(CGPoint)point
                                  color:(UIColor *)color
                                  width:(CGFloat)width
                                 length:(NSNumber *)length
                                  space:(NSNumber *)space
                                   size:(CGSize)size {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.position = point;
    shapeLayer.fillColor = nil;
    // 虚线颜色
    shapeLayer.strokeColor = color.CGColor;
    // 虚线的宽度
    shapeLayer.lineWidth = width;
    shapeLayer.lineJoin = kCALineJoinRound;
    // 第一个参数：线的长度；第二个参数：线间距
    shapeLayer.lineDashPattern = @[length, space];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, size.width, size.height);
    shapeLayer.path = path;
    CGPathRelease(path);
    [self.layer addSublayer:shapeLayer];
}

@end
