//
//  ICPatternLockManager.h
//  ICPatternLock
//
//  Created by _ivanC on 8/30/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICPatternLockDef.h"

@class ICPatternLockViewController;
@protocol ICPatternHandlerProtocol;

@interface ICPatternLockManager : NSObject

#pragma mark - Convenience
// Wheather pattern is setted
+ (BOOL)isPatternSetted;

// Show pattern setter view
+ (ICPatternLockViewController *)showSettingPatternLock:(UIViewController *)parentViewController
                                    animated:(BOOL)animated
                                successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock;

// Show pattern verify view
+ (ICPatternLockViewController *)showVerifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                             forgetPwdBlock:(void(^)(ICPatternLockViewController *lockVC))forgetPwdBlock
                               successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock;

// Show pattern modify view
+ (ICPatternLockViewController *)showModifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                               successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock;

#pragma mark - Resource Bridge
+ (void)loadTextResource:(NSDictionary *)textInfo;
+ (void)loadColorResource:(NSDictionary *)colorInfo;

#pragma mark -
+ (void)setCustomizedPatternHandler:(id<ICPatternHandlerProtocol>)handler;

@end
