//
//  ICResourceBridge.h
//  ICPatternLock
//
//  Created by _ivanC on 8/16/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLResourceTextKeyDef.h"
#import "PLResourceColorKeyDef.h"

@interface ICResourceBridge : NSObject

+ (instancetype)sharedBridge;

- (void)loadTextResource:(NSDictionary *)textInfo;
- (void)loadColorResource:(NSDictionary *)colorInfo;

- (NSString *)textForKey:(NSString *)key;
- (UIColor *)colorForKey:(NSString *)key;

@end

#define ICLocalizedString(key) [[ICResourceBridge sharedBridge] textForKey:key]
#define ICColor(key) [[ICResourceBridge sharedBridge] colorForKey:key]
