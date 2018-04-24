//
//  BRKitMacro.h
//  BRKitDemo
//
//  Created by 任波 on 2018/4/20.
//  Copyright © 2018年 91renb. All rights reserved.
//

#ifndef BRKitMacro_h
#define BRKitMacro_h

/**
    静态库中编写 Category 时的便利宏，用于解决 Category 方法从静态库中加载需要特别设置的问题。
    加入这个宏后，不需要再在 Xcode 的 Other Liker Fliags 中设置链接库参数（-Objc / -all_load / -force_load）
    *******************************************************************************
    使用:在静态库中每个分类的 @implementation 前添加这个宏
    Example:
        #import "NSString+BRAdd.h"
 
        BRSYNTH_DUMMY_CLASS(NSString_BRAdd)
        @implementation NSString (BRAdd)
        @end
 */
#ifndef BRSYNTH_DUMMY_CLASS

    #define BRSYNTH_DUMMY_CLASS(_name_) \
    @interface BRSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
    @implementation BRSYNTH_DUMMY_CLASS_ ## _name_ @end

#endif


#endif /* BRKitMacro_h */
