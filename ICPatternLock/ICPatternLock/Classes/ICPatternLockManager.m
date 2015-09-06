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

@interface ICPatternLockManager () <ICPatternLockViewControllerDataSource, ICPatternLockViewControllerDelegate>

@property (nonatomic, strong) ICPatternLockViewController *patternLockViewController;
@property (nonatomic, copy) void (^successBlock)(ICPatternLockViewController *lockVC);
@property (nonatomic, copy) void (^forgetPwdBlock)(ICPatternLockViewController *lockVC);

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
        }
    }
    
    return s_instance;
}

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
    
    ICPatternLockViewController *lockVC = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeSet];
    lockVC.dataSource = [ICPatternLockManager sharedPatternLockManager];
    lockVC.delegate = [ICPatternLockManager sharedPatternLockManager];
    lockVC.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SET_PATTERN);
    lockVC.view.backgroundColor = ICColor(PL_RES_KEY_COLOR_BACKGROUND);

    [lockVC.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_NORMAL) forState:ICPatternLockNodeStateNormal];
    [lockVC.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_SELECTED) forState:ICPatternLockNodeStateSelected];

    lockVC.patternView.nodeCount = [ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE) count];
    lockVC.patternView.nodeCountPerRow = [ICPreferencesValue(PL_PFRS_KEY_NODE_COUNT_PER_ROW) intValue];
    
    lockVC.resetBarButtonItem.title = ICLocalizedString(PL_RES_KEY_TEXT_RESET);
    
    ICPatternLockNavigationController *navVC = [[ICPatternLockNavigationController alloc] initWithRootViewController:lockVC];
    [parentViewController presentViewController:navVC animated:animated completion:nil];
    
    [[ICPatternLockManager sharedPatternLockManager] setPatternLockViewController:lockVC];
    [[ICPatternLockManager sharedPatternLockManager] setSuccessBlock:successBlock];
    
    [[ICPatternLockManager sharedPatternLockManager] showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET)];

    return lockVC;
}

+ (ICPatternLockViewController *)showVerifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                             forgetPwdBlock:(void(^)(ICPatternLockViewController *lockVC))forgetPwdBlock
                               successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock
{
    ICPatternLockViewController *lockVC = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeVerify];
    lockVC.dataSource = [ICPatternLockManager sharedPatternLockManager];
    lockVC.delegate = [ICPatternLockManager sharedPatternLockManager];
    lockVC.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_GESTURE_UNLOCK);
    lockVC.view.backgroundColor = ICColor(PL_RES_KEY_COLOR_BACKGROUND);

    [lockVC.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_NORMAL) forState:ICPatternLockNodeStateNormal];
    [lockVC.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_SELECTED) forState:ICPatternLockNodeStateSelected];
    lockVC.patternView.nodeCount = [ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE) count];
    lockVC.patternView.nodeCountPerRow = [ICPreferencesValue(PL_PFRS_KEY_NODE_COUNT_PER_ROW) intValue];
    
    [lockVC.forgotButton setTitle:ICLocalizedString(PL_RES_KEY_TEXT_ACTION_FORGET_PATTERN) forState:UIControlStateNormal];
    [lockVC.forgotButton setTitleColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT) forState:UIControlStateNormal];
    [lockVC.modifyButton setTitle:ICLocalizedString(PL_RES_KEY_TEXT_ACTION_MODIFY_PATTERN) forState:UIControlStateNormal];
    [lockVC.modifyButton setTitleColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT) forState:UIControlStateNormal];
    
    ICPatternLockNavigationController *navVC = [[ICPatternLockNavigationController alloc] initWithRootViewController:lockVC];
    [parentViewController presentViewController:navVC animated:animated completion:nil];
    
    [[ICPatternLockManager sharedPatternLockManager] setPatternLockViewController:lockVC];
    [[ICPatternLockManager sharedPatternLockManager] setSuccessBlock:successBlock];
    [[ICPatternLockManager sharedPatternLockManager] setForgetPwdBlock:forgetPwdBlock];
    
    [[ICPatternLockManager sharedPatternLockManager] showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_PATTERN)];

    return lockVC;
}

+ (ICPatternLockViewController *)showModifyPatternLock:(UIViewController *)parentViewController
                                   animated:(BOOL)animated
                               successBlock:(void(^)(ICPatternLockViewController *lockVC))successBlock
{
    ICPatternLockViewController *lockVC = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeModify];
    lockVC.dataSource = [ICPatternLockManager sharedPatternLockManager];
    lockVC.delegate = [ICPatternLockManager sharedPatternLockManager];
    lockVC.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_PATTERN);
    lockVC.view.backgroundColor = ICColor(PL_RES_KEY_COLOR_BACKGROUND);

    [lockVC.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_NORMAL) forState:ICPatternLockNodeStateNormal];
    [lockVC.patternView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_SELECTED) forState:ICPatternLockNodeStateSelected];
    lockVC.patternView.nodeCount = [ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE) count];
    lockVC.patternView.nodeCountPerRow = [ICPreferencesValue(PL_PFRS_KEY_NODE_COUNT_PER_ROW) intValue];
    
    lockVC.resetBarButtonItem.title = ICLocalizedString(PL_RES_KEY_TEXT_RESET);
    lockVC.closeBarButtonItem.title = ICLocalizedString(PL_RES_KEY_TEXT_CLOSE);

    ICPatternLockNavigationController *navVC = [[ICPatternLockNavigationController alloc] initWithRootViewController:lockVC];
    [parentViewController presentViewController:navVC animated:animated completion:nil];
    
    [[ICPatternLockManager sharedPatternLockManager] setPatternLockViewController:lockVC];
    [[ICPatternLockManager sharedPatternLockManager] setSuccessBlock:successBlock];
    
    [[ICPatternLockManager sharedPatternLockManager] showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN)];

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

#pragma mark - Hint Message Display
- (void)showNormalHintMessage:(NSString *)message
{
    [self.patternLockViewController showHintMessage:message withTextColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT) shake:NO];
}

- (void)showWarningHintMessage:(NSString *)message
{
    [self.patternLockViewController showHintMessage:message withTextColor:ICColor(PL_RES_KEY_COLOR_WARN_TEXT) shake:YES];
}

#pragma mark - ICPatternLockViewController DataSource
- (BOOL)patternLockViewController:(ICPatternLockViewController *)patternLockViewController verifyPattern:(NSString *)pattern;
{
    NSArray *decryptTable = ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE);
    NSMutableString *parrtenStr = [NSMutableString string];
    for (int i = 0; i < [pattern length]; i++)
    {
        NSString *indexStr = [pattern substringWithRange:NSMakeRange(i, 1)];
        [parrtenStr appendString:decryptTable[[indexStr intValue]]];
    }
    
    return  [[ICPatternHandler sharedPatternHandler] verifypattern:pattern];
}

- (BOOL)patternLockViewController:(ICPatternLockViewController *)patternLockViewController updatePattern:(NSString *)pattern
{
    [[ICPatternHandler sharedPatternHandler] setPattern:pattern];
    return YES;
}

#pragma mark - ICPatternLockViewController Delegate
- (void)patternLockViewControllerWillStartDrawPattern:(ICPatternLockViewController *)patternLockViewController
{
    if(patternLockViewController.type == ICPatternLockTypeSet)
    {
        if(patternLockViewController.state == ICPatternLockStateNone)
        {
            [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET)];
        }
        else
        {
            [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_CONFIRM_SET)];
        }
    }
    else if(patternLockViewController.type == ICPatternLockTypeVerify)
    {
        [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_PATTERN)];
    }
    else if (patternLockViewController.type == ICPatternLockTypeModify)
    {
        NSString *msg = (patternLockViewController.state == ICPatternLockStatePatternVerified) ? ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET) : ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN);
        [self showNormalHintMessage:msg];
    }
}

- (void)patternLockViewControllerPatternVerified:(ICPatternLockViewController *)patternLockViewController
{
    [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_SUCCEED)];
    
    if(patternLockViewController.type == ICPatternLockTypeVerify)
    {
        patternLockViewController.view.userInteractionEnabled = NO;
        if(_successBlock != nil) _successBlock(patternLockViewController);
    }
    else if (patternLockViewController.type == ICPatternLockTypeModify)
    {
        [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET)];
    }
}

- (void)patternLockViewControllerPatternUpdated:(ICPatternLockViewController *)patternLockViewController
{
    if (patternLockViewController.state == ICPatternLockStateFirstPatternSetted)
    {
        [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_CONFIRM_SET)];
    }
    else if (patternLockViewController.state == ICPatternLockStateSecondPatternConfirmed)
    {
        
        patternLockViewController.view.userInteractionEnabled = NO;
        
        [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SET_SUCCEED)];
        
        if(_successBlock != nil) _successBlock(patternLockViewController);
        
        if(patternLockViewController.type == ICPatternLockTypeModify)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [patternLockViewController.navigationController popViewControllerAnimated:YES];
            });
        }

    }
}

- (void)patternLockViewController:(ICPatternLockViewController *)patternLockViewController failWithError:(NSError *)error
{
    if (error.code == ICPatternLockErrorNotEnoughNodes)
    {
        NSNumber *minNodeCount = ICPreferencesValue(PL_PFRS_KEY_MINIMUM_NODE_COUNT);
        [self showWarningHintMessage:[NSString stringWithFormat:ICLocalizedString(PL_RES_KEY_TEXT_PATTERN_TOO_SHORT), minNodeCount]];
    }
    else if (error.code == ICPatternLockErrorPatternsNotMatch)
    {
        [self showWarningHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SECOND_WRONG)];
    }
    else if (error.code == ICPatternLockErrorVerifyPatternFail)
    {
        [self showWarningHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_ERROR)];
    }
}

- (void)patternLockViewControllerForgotClicked:(ICPatternLockViewController *)patternLockViewController
{
    if (_forgetPwdBlock) {
        _forgetPwdBlock(patternLockViewController);
    }
}

- (void)patternLockViewControllerModifyClicked:(ICPatternLockViewController *)patternLockViewController
{
    ICPatternLockViewController *patternViewController = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeModify];
    patternViewController.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_PATTERN);
    patternViewController.navigationItem.leftBarButtonItem = nil;
    [patternLockViewController showHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN)
                                                                 withTextColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT)
                                                                 shake:NO];
    [patternLockViewController.navigationController pushViewController:patternViewController animated:YES];
}

- (void)patternLockViewControllerResetClicked:(ICPatternLockViewController *)patternLockViewController
{
    [self.self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET)];        
}

@end
