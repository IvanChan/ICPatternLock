//
//  ICPreferences.h
//  ICPatternLock
//
//  Created by _ivanC on 8/23/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPreferences : NSObject

+ (instancetype)sharedPreferences;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key;

@end

#define ICPreferencesValue(key) [[ICPreferences sharedPreferences] objectForKey:key]
#define ICPreferencesSetValue(value, key) [[ICPreferences sharedPreferences] setObject:value forKey:key]