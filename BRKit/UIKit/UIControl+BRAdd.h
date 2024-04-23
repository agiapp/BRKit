//
//  UIControl+BRAdd.h
//  BRKitDemo
//
//  Created by renbo on 2018/5/17.
//  Copyright © 2018年 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BRAdd)
/** 多少秒后可以继续响应事件（防止UI控件短时间多次激活事件） */
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

@end
