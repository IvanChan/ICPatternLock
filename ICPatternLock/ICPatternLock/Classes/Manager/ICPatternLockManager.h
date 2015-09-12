//
//  ICPatternLockManager.h
//  ICPatternLock
//
//  Created by _ivanC on 8/30/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICPatternLockViewController;
@protocol ICPatternHandlerProtocol;
@interface ICPatternLockManager : NSObject

#pragma mark - Convenience
// Wheather pattern is setted
+ (BOOL)isPatternSetted;

// Show pattern setter view
+ (ICPatternLockViewController *)showSettingPatternLock:(UIViewController *)parentViewController
                                    animated:(BOOL)animated
                                successBlock:(void(^)(ICPatternLockViewController *patternLockViewController))successBlock;

// Show pattern verify view
+ (ICPatternLockViewController *)showVerifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                             forgetPwdBlock:(void(^)(ICPatternLockViewController *patternLockViewController))forgetPwdBlock
                               successBlock:(void(^)(ICPatternLockViewController *patternLockViewController))successBlock;

// Show pattern modify view
+ (ICPatternLockViewController *)showModifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                               successBlock:(void(^)(ICPatternLockViewController *patternLockViewController))successBlock;

#pragma mark - Resource Bridge
+ (void)loadTextResource:(NSDictionary *)textInfo;
+ (void)loadColorResource:(NSDictionary *)colorInfo;

#pragma mark - Preferences
- (void)setPreferencesValue:(id)value forKey:(NSString *)key;

#pragma mark - PatternHandler
+ (void)setCustomizedPatternHandler:(id<ICPatternHandlerProtocol>)handler;

@end
