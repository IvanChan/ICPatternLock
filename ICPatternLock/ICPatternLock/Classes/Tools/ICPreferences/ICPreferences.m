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
        }
    }
    
    return s_instance;
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
    
    @synchronized (self) {

        return self.preferences[key];
    }
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    if ([key length] <= 0 || value == nil)
    {
        return;
    }
    
    @synchronized (self) {

        self.preferences[key] = value;
    }
}

@end
