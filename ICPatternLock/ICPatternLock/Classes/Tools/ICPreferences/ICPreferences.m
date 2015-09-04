//
//  ICPreferences.m
//  ICPatternLock
//
//  Created by _ivanC on 8/23/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPreferences.h"

@interface ICPreferences ()

@property (nonatomic) NSMutableDictionary *preferences;

@end

@implementation ICPreferences

#pragma mark - Lifecycle
+ (instancetype)sharedPreferences
{
    static ICPreferences *s_instance = nil;
    
    if (s_instance == nil)
    {
        @synchronized (self) {
            
            s_instance = [[ICPreferences alloc] init];
            [s_instance loadDefaultValues];
        }
    }
    
    return s_instance;
}

- (void)loadDefaultValues
{
    [self setObject:[NSNumber numberWithFloat:PL_PFRS_DEFAULT_CENTER_SOLID_CIRCLE_SCALE] forKey:PL_PFRS_KEY_CENTER_SOLID_CIRCLE_SCALE];
    [self setObject:[NSNumber numberWithFloat:PL_PFRS_DEFAULT_RING_LINE_WIDTH] forKey:PL_PFRS_KEY_RING_LINE_WIDTH];
    [self setObject:[NSNumber numberWithUnsignedInteger:PL_PFRS_DEFAULT_NODE_COUNT_PER_ROW] forKey:PL_PFRS_KEY_NODE_COUNT_PER_ROW];
    [self setObject:[NSNumber numberWithUnsignedInteger:PL_PFRS_DEFAULT_MINIMUM_NODE_COUNT] forKey:PL_PFRS_KEY_MINIMUM_NODE_COUNT];
    [self setObject:PL_PFRS_DEFAULT_NODE_TABLE forKey:PL_PFRS_KEY_NODE_TABLE];
}

#pragma mark - Getters
- (NSMutableDictionary *)preferences
{
    if (_preferences == nil)
    {
        _preferences = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return _preferences;
}

#pragma mark - Ops
- (id)objectForKey:(NSString *)key
{
    if ([key length] <= 0)
    {
        return nil;
    }
    
    return self.preferences[key];
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    if ([key length] <= 0 || value == nil)
    {
        return;
    }
    
    self.preferences[key] = value;
}

@end
