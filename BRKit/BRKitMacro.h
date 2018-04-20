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
    Add this macro before each category implementation, so we don't have to use
    -all_load or -force_load to load object files from static libraries that only
    contain categories and no classes.
    More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
    *******************************************************************************
    Example:
        BRSYNTH_DUMMY_CLASS(NSString_BRAdd)
 */
#ifndef BRSYNTH_DUMMY_CLASS

    #define BRSYNTH_DUMMY_CLASS(_name_) \
    @interface BRSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
    @implementation BRSYNTH_DUMMY_CLASS_ ## _name_ @end

#endif


#endif /* BRKitMacro_h */
