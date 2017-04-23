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
        }
    }
    
    return s_instance;
}

#pragma mark -
- (void)loadTextResource:(NSDictionary *)textInfo
{
    @synchronized (self) {

        if ([self.resTextDict count] > 0)
        {
            NSMutableDictionary *oldInfo = [self.resTextDict mutableCopy];
            [oldInfo addEntriesFromDictionary:textInfo];
            self.resTextDict = [oldInfo copy];
        }
        else
        {
            self.resTextDict = [textInfo copy];
        }
    }
}

- (void)loadColorResource:(NSDictionary *)colorInfo
{
    @synchronized (self) {
        
        if ([self.resColorDict count] > 0)
        {
            NSMutableDictionary *oldInfo = [self.resColorDict mutableCopy];
            [oldInfo addEntriesFromDictionary:colorInfo];
            self.resColorDict = [oldInfo copy];
        }
        else
        {
            self.resColorDict = [colorInfo copy];
        }
    }
}

#pragma mark - Convenience
- (NSString *)textForKey:(NSString *)key
{
    if ([key length] <= 0)
    {
        return nil;
    }
    
    @synchronized (self) {

        NSString *textStr = self.resTextDict[key];
        assert(textStr);
        return textStr ? textStr : @"";
    }
}

- (UIColor *)colorForKey:(NSString *)key
{
    if ([key length] <= 0)
    {
        return nil;
    }
    
    @synchronized (self) {

        UIColor *color = self.resColorDict[key];
        assert(color);
        return color;
    }
}
@end
