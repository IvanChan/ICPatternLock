//
//  ICResourceBridge.m
//  ICPatternLock
//
//  Created by _ivanC on 8/16/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICResourceBridge.h"

@interface ICResourceBridge ()

@property (nonatomic) NSDictionary *resTextDict;
@property (nonatomic) NSDictionary *resColorDict;

@end

@implementation ICResourceBridge

#pragma mark - Lifecycle
+ (instancetype)sharedBridge
{
    static ICResourceBridge *s_instance = nil;
    
    if (s_instance == nil)
    {
        @synchronized (self) {
            
            s_instance = [[ICResourceBridge alloc] init];
            [s_instance loadDefaultColorResource];
            [s_instance loadDefaultTextResource];
        }
    }
    
    return s_instance;
}

#pragma mark -
- (void)loadDefaultTextResource
{
    @synchronized (self) {
        
        self.resTextDict = @{PL_RES_KEY_TEXT_PATTERN_TOO_SHORT:PL_RES_DEFAULT_TEXT_PATTERN_TOO_SHORT,
                             PL_RES_KEY_TEXT_CLOSE:PL_RES_DEFAULT_TEXT_CLOSE,
                             PL_RES_KEY_TEXT_RESET:PL_RES_DEFAULT_TEXT_RESET,
                             PL_RES_KEY_TEXT_TITLE_SET_PATTERN:PL_RES_DEFAULT_TEXT_TITLE_SET_PATTERN,
                             PL_RES_KEY_TEXT_TITLE_GESTURE_UNLOCK:PL_RES_DEFAULT_TEXT_TITLE_GESTURE_UNLOCK,
                             PL_RES_KEY_TEXT_TITLE_MODIFY_PATTERN:PL_RES_DEFAULT_TEXT_TITLE_MODIFY_PATTERN,
                             PL_RES_KEY_TEXT_TITLE_FIRST_SET:PL_RES_DEFAULT_TEXT_TITLE_FIRST_SET,
                             PL_RES_KEY_TEXT_TITLE_CONFIRM_SET:PL_RES_DEFAULT_TEXT_TITLE_CONFIRM_SET,
                             PL_RES_KEY_TEXT_TITLE_SECOND_WRONG:PL_RES_DEFAULT_TEXT_TITLE_SECOND_WRONG,
                             PL_RES_KEY_TEXT_TITLE_SET_SUCCEED:PL_RES_DEFAULT_TEXT_TITLE_SET_SUCCEED,
                             PL_RES_KEY_TEXT_TITLE_VERIFY_PATTERN:PL_RES_DEFAULT_TEXT_TITLE_VERIFY_PATTERN,
                             PL_RES_KEY_TEXT_TITLE_VERIFY_ERROR:PL_RES_DEFAULT_TEXT_TITLE_VERIFY_ERROR,
                             PL_RES_KEY_TEXT_TITLE_VERIFY_SUCCEED:PL_RES_DEFAULT_TEXT_TITLE_VERIFY_SUCCEED,
                             PL_RES_KEY_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN:PL_RES_DEFAULT_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN,
                             PL_RES_KEY_TEXT_ACTION_FORGET_PATTERN:PL_RES_DEFAULT_TEXT_ACTION_FORGET_PATTERN,
                             PL_RES_KEY_TEXT_ACTION_MODIFY_PATTERN:PL_RES_DEFAULT_TEXT_ACTION_MODIFY_PATTERN};
    }
}

- (void)loadTextResource:(NSDictionary *)textInfo
{
    @synchronized (self) {
        NSMutableDictionary *oldInfo = [self.resTextDict mutableCopy];
        [oldInfo addEntriesFromDictionary:textInfo];
        self.resTextDict = [oldInfo copy];
    }
}

- (void)loadDefaultColorResource
{
    @synchronized (self) {
        
        self.resColorDict = @{PL_RES_KEY_COLOR_BACKGROUND:PL_RES_DEFAULT_COLOR_BACKGROUND,
                              PL_RES_KEY_COLOR_NAVI_TEXT:PL_RES_DEFAULT_COLOR_NAVI_TEXT,
                              PL_RES_KEY_COLOR_HINT_TEXT:PL_RES_DEFAULT_COLOR_HINT_TEXT,
                              PL_RES_KEY_COLOR_CIRCLE_LINE_NORMAL:PL_RES_DEFAULT_COLOR_CIRCLE_LINE_NORMAL,
                              PL_RES_KEY_COLOR_CIRCLE_LINE_SELECTED:PL_RES_DEFAULT_COLOR_CIRCLE_LINE_SELECTED,
                              PL_RES_KEY_COLOR_CIRCLE_NORMAL:PL_RES_DEFALUT_COLOR_CIRCLE_NORMAL,
                              PL_RES_KEY_COLOR_CIRCLE_SELECTED:PL_RES_DEFALUT_COLOR_CIRCLE_SELECTED,
                              PL_RES_KEY_COLOR_WARN_TEXT:PL_RES_DEFAULT_COLOR_WARN_TEXT,
                              PL_RES_KEY_COLOR_ACTION_TEXT:PL_RES_DEFAULT_COLOR_ACTION_TEXT
                              };
    }
}

- (void)loadColorResource:(NSDictionary *)colorInfo
{
    @synchronized (self) {
        NSMutableDictionary *oldInfo = [self.resColorDict mutableCopy];
        [oldInfo addEntriesFromDictionary:colorInfo];
        self.resColorDict = [oldInfo copy];
    }
}

#pragma mark - Convenience
- (NSString *)textForKey:(NSString *)key
{
    @synchronized (self) {

        if ([self.resTextDict count] <= 0)
        {
            [self loadDefaultTextResource];
        }
    }
    
    if ([key length] <= 0)
    {
        return @"";
    }
    
    NSString *textStr = self.resTextDict[key];
    assert(textStr);
    return textStr ? textStr : @"";
}

- (UIColor *)colorForKey:(NSString *)key
{
    @synchronized (self) {
        
        if ([self.resColorDict count] <= 0)
        {
            [self loadDefaultColorResource];
        }
    }

    UIColor *color = self.resColorDict[key];
    assert(color);
    return color;
}
@end
