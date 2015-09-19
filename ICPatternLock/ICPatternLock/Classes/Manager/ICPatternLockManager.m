//
//  ICPatternLockManager.m
//  ICPatternLock
//
//  Created by _ivanC on 8/30/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternLockManager.h"

#import "ICResourceBridge.h"
#import "ICPreferences.h"
#import "ICPatternHandler.h"

#import "ICPatternLockViewController.h"
#import "ICPatternLockNavigationController.h"
#import "ICPatternLockView.h"
#import "ICPatternLockHintLabel.h"

#import "PLPreferencesKeyDef.h"
#import "PLResourceTextKeyDef.h"
#import "PLResourceColorKeyDef.h"

@interface ICPatternLockManager () <ICPatternLockViewControllerDataSource, ICPatternLockViewControllerDelegate>

@property (nonatomic, copy) void (^successBlock)(ICPatternLockViewController *patternLockViewController);
@property (nonatomic, copy) void (^forgetPwdBlock)(ICPatternLockViewController *patternLockViewController);

@property (nonatomic, assign, getter=isPreferenceLoaded) BOOL preferenceLoaded;
@property (nonatomic, assign, getter=isColorResourceLoaded) BOOL colorResourceLoaded;
@property (nonatomic, assign, getter=isTextResourceLoaded) BOOL textResourceLoaded;

@end

@implementation ICPatternLockManager

#pragma mark - Lifecycle
+ (instancetype)sharedPatternLockManager
{
    static ICPatternLockManager *s_instance = nil;
    
    if (s_instance == nil)
    {
        @synchronized (self) {
            
            s_instance = [[ICPatternLockManager alloc] init];
            [s_instance loadDefaultPreferences];
        }
    }
    
    return s_instance;
}

#pragma mark - Load Default Resoure & Preferences
- (void)loadDefaultPreferences
{
    if ([self isPreferenceLoaded])
    {
        return;
    }
    self.preferenceLoaded = YES;
    
    ICPreferencesSetValue([NSNumber numberWithFloat:PL_PFRS_DEFAULT_CENTER_SOLID_CIRCLE_SCALE], PL_PFRS_KEY_CENTER_SOLID_CIRCLE_SCALE);
    ICPreferencesSetValue([NSNumber numberWithFloat:PL_PFRS_DEFAULT_RING_LINE_WIDTH], PL_PFRS_KEY_RING_LINE_WIDTH);
    ICPreferencesSetValue([NSNumber numberWithUnsignedInteger:PL_PFRS_DEFAULT_NODE_COUNT_PER_ROW], PL_PFRS_KEY_NODE_COUNT_PER_ROW);
    ICPreferencesSetValue([NSNumber numberWithUnsignedInteger:PL_PFRS_DEFAULT_MINIMUM_NODE_COUNT], PL_PFRS_KEY_MINIMUM_NODE_COUNT);
    ICPreferencesSetValue(PL_PFRS_DEFAULT_NODE_TABLE, PL_PFRS_KEY_NODE_TABLE);
}

- (void)loadDefaultTextResource
{
    if ([self isTextResourceLoaded])
    {
        return;
    }
    self.textResourceLoaded = YES;
    
    NSDictionary *resTextDict = @{PL_RES_KEY_TEXT_PATTERN_TOO_SHORT:PL_RES_DEFAULT_TEXT_PATTERN_TOO_SHORT,
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
    
    [[ICResourceBridge sharedBridge] loadTextResource:resTextDict];
}

- (void)loadDefaultColorResource
{
    if ([self isColorResourceLoaded])
    {
        return;
    }
    self.colorResourceLoaded = YES;
    
    NSDictionary *resColorDict = @{PL_RES_KEY_COLOR_BACKGROUND:PL_RES_DEFAULT_COLOR_BACKGROUND,
                                   PL_RES_KEY_COLOR_NAVI_TEXT:PL_RES_DEFAULT_COLOR_NAVI_TEXT,
                                   PL_RES_KEY_COLOR_HINT_TEXT:PL_RES_DEFAULT_COLOR_HINT_TEXT,
                                   PL_RES_KEY_COLOR_CIRCLE_LINE_NORMAL:PL_RES_DEFAULT_COLOR_CIRCLE_LINE_NORMAL,
                                   PL_RES_KEY_COLOR_CIRCLE_LINE_SELECTED:PL_RES_DEFAULT_COLOR_CIRCLE_LINE_SELECTED,
                                   PL_RES_KEY_COLOR_CIRCLE_NORMAL:PL_RES_DEFALUT_COLOR_CIRCLE_NORMAL,
                                   PL_RES_KEY_COLOR_CIRCLE_SELECTED:PL_RES_DEFALUT_COLOR_CIRCLE_SELECTED,
                                   PL_RES_KEY_COLOR_WARN_TEXT:PL_RES_DEFAULT_COLOR_WARN_TEXT,
                                   PL_RES_KEY_COLOR_ACTION_TEXT:PL_RES_DEFAULT_COLOR_ACTION_TEXT
                                   };
    
    [[ICResourceBridge sharedBridge] loadColorResource:resColorDict];
}

+ (void)loadDefaultResource
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[ICPatternLockManager sharedPatternLockManager] loadDefaultTextResource];
        [[ICPatternLockManager sharedPatternLockManager] loadDefaultColorResource];
    });
}

#pragma mark - Getters
+ (BOOL)isPatternSetted
{
    return [[ICPatternHandler sharedPatternHandler] isPatternSetted];
}

#pragma mark - Convenience
+ (ICPatternLockViewController *)patternLockViewControllerWithType:(ICPatternLockType)type
{
    ICPatternLockViewController *patternLockViewController = [[ICPatternLockViewController alloc] initWithType:type];
    patternLockViewController.dataSource = [ICPatternLockManager sharedPatternLockManager];
    patternLockViewController.delegate = [ICPatternLockManager sharedPatternLockManager];
    patternLockViewController.view.backgroundColor = ICColor(PL_RES_KEY_COLOR_BACKGROUND);
    
    patternLockViewController.patternView.nodeCount = [ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE) count];
    patternLockViewController.patternView.nodeCountPerRow = [ICPreferencesValue(PL_PFRS_KEY_NODE_COUNT_PER_ROW) intValue];
    
    [patternLockViewController.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_NORMAL) forState:ICPatternLockNodeStateNormal];
    [patternLockViewController.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_SELECTED) forState:ICPatternLockNodeStateSelected];
    
    patternLockViewController.hintLabel.textColor = ICColor(PL_RES_KEY_COLOR_HINT_TEXT);
    
    if (type == ICPatternLockTypeSet)
    {
        patternLockViewController.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SET_PATTERN);
        patternLockViewController.resetBarButtonItem.title = ICLocalizedString(PL_RES_KEY_TEXT_RESET);
    }
    else if (type == ICPatternLockTypeVerify)
    {
        patternLockViewController.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_GESTURE_UNLOCK);
        
        [patternLockViewController.forgotButton setTitle:ICLocalizedString(PL_RES_KEY_TEXT_ACTION_FORGET_PATTERN) forState:UIControlStateNormal];
        [patternLockViewController.forgotButton setTitleColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT) forState:UIControlStateNormal];
        [patternLockViewController.modifyButton setTitle:ICLocalizedString(PL_RES_KEY_TEXT_ACTION_MODIFY_PATTERN) forState:UIControlStateNormal];
        [patternLockViewController.modifyButton setTitleColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT) forState:UIControlStateNormal];
    }
    else if (type == ICPatternLockTypeModify)
    {
        patternLockViewController.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_PATTERN);
        
        patternLockViewController.resetBarButtonItem.title = ICLocalizedString(PL_RES_KEY_TEXT_RESET);
        patternLockViewController.closeBarButtonItem.title = ICLocalizedString(PL_RES_KEY_TEXT_CLOSE);
    }
    
    return patternLockViewController;
}

+ (ICPatternLockViewController *)presentPatternLockViewController:(ICPatternLockType)type
                  inParentViewController:(UIViewController *)parentViewController
                                animated:(BOOL)animated
{
    if (parentViewController == nil)
    {
        return nil;
    }
    
    [self loadDefaultResource];
    
    ICPatternLockViewController *patternLockViewController = [self patternLockViewControllerWithType:type];
    
    ICPatternLockNavigationController *navigationViewController = [[ICPatternLockNavigationController alloc] initWithRootViewController:patternLockViewController];
    [navigationViewController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:ICColor(PL_RES_KEY_COLOR_NAVI_TEXT),
                                                 NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    [parentViewController presentViewController:navigationViewController animated:animated completion:nil];
    
    return patternLockViewController;
}

+ (ICPatternLockViewController *)showSettingPatternLock:(UIViewController *)parentViewController
                                    animated:(BOOL)animated
                                successBlock:(void(^)(ICPatternLockViewController *patternLockViewController))successBlock
{
    [[ICPatternLockManager sharedPatternLockManager] setSuccessBlock:successBlock];
    
    return [self presentPatternLockViewController:ICPatternLockTypeSet inParentViewController:parentViewController animated:animated];
}

+ (ICPatternLockViewController *)showVerifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                             forgetPwdBlock:(void(^)(ICPatternLockViewController *patternLockViewController))forgetPwdBlock
                               successBlock:(void(^)(ICPatternLockViewController *patternLockViewController))successBlock
{
    [[ICPatternLockManager sharedPatternLockManager] setSuccessBlock:successBlock];
    [[ICPatternLockManager sharedPatternLockManager] setForgetPwdBlock:forgetPwdBlock];
    
    return [self presentPatternLockViewController:ICPatternLockTypeVerify inParentViewController:parentViewController animated:animated];
}

+ (ICPatternLockViewController *)showModifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                               successBlock:(void(^)(ICPatternLockViewController *patternLockViewController))successBlock
{
    [[ICPatternLockManager sharedPatternLockManager] setSuccessBlock:successBlock];
    
    return [self presentPatternLockViewController:ICPatternLockTypeModify inParentViewController:parentViewController animated:animated];
}

#pragma mark - Resource Bridge
+ (void)loadTextResource:(NSDictionary *)textInfo
{
    if ([textInfo count] <= 0)
    {
        return;
    }

    [[ICPatternLockManager sharedPatternLockManager] setTextResourceLoaded:YES];
    [[ICResourceBridge sharedBridge] loadTextResource:textInfo];
}

+ (void)loadColorResource:(NSDictionary *)colorInfo
{
    if ([colorInfo count] <= 0)
    {
        return;
    }
    
    [[ICPatternLockManager sharedPatternLockManager] setColorResourceLoaded:YES];
    [[ICResourceBridge sharedBridge] loadColorResource:colorInfo];
}

#pragma mark - Preferences
+ (void)setPreferencesValue:(id)value forKey:(NSString *)key
{
    ICPreferencesSetValue(value, key);
}

#pragma mark - PatternHandler
+ (void)setCustomizedPatternHandler:(id<ICPatternHandlerProtocol>)handler;
{
    [ICPatternHandler setCustomizedHandler:handler];
}

#pragma mark - ICPatternLockViewController DataSource
- (UIColor *)hintMessageColorForState:(ICPatternLockState)state
{
    return ICColor(PL_RES_KEY_COLOR_HINT_TEXT);
}

- (NSString *)hintMessageForState:(ICPatternLockState)state
{
    NSString *message = nil;
    switch (state)
    {
        case ICPatternLockStatePreSet:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET);
        }
            break;
        case ICPatternLockStateSetFirstSetted:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_CONFIRM_SET);
        }
            break;
        //case ICPatternLockStateSetSecondConfirmed:
        case ICPatternLockStateSetted:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SET_SUCCEED);
        }
            break;
        case ICPatternLockStatePreVerify:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_PATTERN);
        }
            break;
        case ICPatternLockStateVerified:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_SUCCEED);
        }
            break;
        case ICPatternLockStatePreModify:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN);
        }
            break;
        case ICPatternLockStateModifyOldVerified:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET);
        }
            break;
        case ICPatternLockStateModifyFirstSeted:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_CONFIRM_SET);
        }
            break;
        //case ICPatternLockStateModifySecondConfirmed:
        case ICPatternLockStateModified:
        {
            message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SET_SUCCEED);
        }
            break;
            
        default:
        {
            message = @"";
        }
            break;
    }
    
    return message;
}

- (BOOL)patternLockViewController:(ICPatternLockViewController *)patternLockViewController verifyPattern:(NSString *)pattern;
{
    NSArray *decryptTable = ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE);
    NSMutableString *parrtenStr = [NSMutableString string];
    for (int i = 0; i < [pattern length]; i++)
    {
        NSString *indexStr = [pattern substringWithRange:NSMakeRange(i, 1)];
        [parrtenStr appendString:decryptTable[[indexStr intValue]]];
    }
    
    return [[ICPatternHandler sharedPatternHandler] verifypattern:pattern];
}

- (BOOL)patternLockViewController:(ICPatternLockViewController *)patternLockViewController updatePattern:(NSString *)pattern
{
    [[ICPatternHandler sharedPatternHandler] updatePattern:pattern];
    return YES;
}

#pragma mark - ICPatternLockViewController Delegate
- (void)patternLockViewControllerPatternVerified:(ICPatternLockViewController *)patternLockViewController
{
    if(patternLockViewController.type == ICPatternLockTypeVerify)
    {
        patternLockViewController.view.userInteractionEnabled = NO;
        if(self.successBlock)
        {
            self.successBlock(patternLockViewController);
        }
    }
}

- (void)patternLockViewControllerPatternUpdated:(ICPatternLockViewController *)patternLockViewController
{
    if (patternLockViewController.state == ICPatternLockStateSetted
        || patternLockViewController.state == ICPatternLockStateModified)
    {
        patternLockViewController.view.userInteractionEnabled = NO;
        
        if(self.successBlock)
        {
            self.successBlock(patternLockViewController);
        }
    }
}

- (void)patternLockViewController:(ICPatternLockViewController *)patternLockViewController failWithError:(NSError *)error
{
    NSString *message = nil;
    if (error.code == ICPatternLockErrorNotEnoughNodes)
    {
        NSNumber *minNodeCount = ICPreferencesValue(PL_PFRS_KEY_MINIMUM_NODE_COUNT);
        message = [NSString stringWithFormat:ICLocalizedString(PL_RES_KEY_TEXT_PATTERN_TOO_SHORT), minNodeCount];
    }
    else if (error.code == ICPatternLockErrorPatternsNotMatch)
    {
        message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SECOND_WRONG);
    }
    else if (error.code == ICPatternLockErrorVerifyPatternFail)
    {
        message = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_ERROR);
    }
    
    [patternLockViewController showHintMessage:message withTextColor:ICColor(PL_RES_KEY_COLOR_WARN_TEXT) shake:YES];
}

- (void)patternLockViewControllerForgotClicked:(ICPatternLockViewController *)patternLockViewController
{
    if (self.forgetPwdBlock)
    {
        self.forgetPwdBlock(patternLockViewController);
    }
}

- (void)patternLockViewControllerModifyClicked:(ICPatternLockViewController *)patternLockViewController
{
    ICPatternLockViewController *patternViewController = [ICPatternLockManager patternLockViewControllerWithType:ICPatternLockTypeModify];
    patternViewController.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_PATTERN);
    patternViewController.navigationItem.leftBarButtonItem = nil;
    [patternLockViewController.navigationController pushViewController:patternViewController animated:YES];
}

@end
