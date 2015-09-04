//
//  ICPatternLockManager.m
//  ICPatternLock
//
//  Created by _ivanC on 8/30/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternLockManager.h"
#import "ICResourceBridge.h"
#import "ICPatternHandler.h"
#import "ICPatternLockViewController.h"
#import "ICPatternLockNavigationController.h"

@implementation ICPatternLockManager

#pragma mark - Getters
+ (BOOL)isPatternSetted
{
    return [[ICPatternHandler sharedPatternHandler] isPatternSetted];
}

#pragma mark - Convenience
+ (ICPatternLockViewController *)showSettingPatternLock:(UIViewController *)parentViewController
                                    animated:(BOOL)animated
                                successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock
{
    
    ICPatternLockViewController *lockVC = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeSet successBlock:successBlock forgetPwdBlock:nil];
    lockVC.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SET_PATTERN);
    
    ICPatternLockNavigationController *navVC = [[ICPatternLockNavigationController alloc] initWithRootViewController:lockVC];
    [parentViewController presentViewController:navVC animated:animated completion:nil];
    
    return lockVC;
}

+ (ICPatternLockViewController *)showVerifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                             forgetPwdBlock:(void(^)(ICPatternLockViewController *lockVC))forgetPwdBlock
                               successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock
{
    ICPatternLockViewController *lockVC = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeVerify successBlock:successBlock forgetPwdBlock:forgetPwdBlock];
    lockVC.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_GESTURE_UNLOCK);

    ICPatternLockNavigationController *navVC = [[ICPatternLockNavigationController alloc] initWithRootViewController:lockVC];
    [parentViewController presentViewController:navVC animated:animated completion:nil];
    
    return lockVC;
}

+ (ICPatternLockViewController *)showModifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                               successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock
{
    ICPatternLockViewController *lockVC = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeModify successBlock:successBlock forgetPwdBlock:nil];
    lockVC.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_PATTERN);

    ICPatternLockNavigationController *navVC = [[ICPatternLockNavigationController alloc] initWithRootViewController:lockVC];
    [parentViewController presentViewController:navVC animated:animated completion:nil];
    

    return lockVC;
}

#pragma mark - Resource Bridge
+ (void)loadTextResource:(NSDictionary *)textInfo
{
    if ([textInfo count] <= 0)
    {
        return;
    }
    
    [[ICResourceBridge sharedBridge] loadTextResource:textInfo];
}

+ (void)loadColorResource:(NSDictionary *)colorInfo
{
    if ([colorInfo count] <= 0)
    {
        return;
    }
    
    [[ICResourceBridge sharedBridge] loadColorResource:colorInfo];
}

#pragma mark - PatternHandler
+ (void)setCustomizedPatternHandler:(id<ICPatternHandlerProtocol>)handler;
{
    [ICPatternHandler setCustomizedHandler:handler];
}

@end
