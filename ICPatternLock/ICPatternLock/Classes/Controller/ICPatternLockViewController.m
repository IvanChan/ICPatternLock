//
//  ICPatternLockViewController.m
//  ICPatternLock
//
//  Created by _ivanC on 15/8/28.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternLockViewController.h"
#import "ICPatternLockNavigationController.h"

#import "ICPatternLockDef.h"
#import "ICPatternLockManager.h"

#import "ICPatternLockHintLabel.h"
#import "ICPatternLockView.h"

#import "ICResourceBridge.h"
#import "ICPatternHandler.h"
#import "ICPreferences.h"

@interface ICPatternLockViewController () <ICPatternLockViewDelegate>

@property (nonatomic, copy) void (^successBlock)(ICPatternLockViewController *lockVC);
@property (nonatomic, copy) void (^forgetPwdBlock)(ICPatternLockViewController *lockVC);

@property (nonatomic) ICPatternLockType type;

@property (nonatomic, strong) UIBarButtonItem *resetItem;
@property (nonatomic) ICPatternLockHintLabel *hintLabel;
@property (nonatomic) ICPatternLockView *lockView;
@property (nonatomic) UIView *actionView;

@property (nonatomic, copy) NSString *firstSetPattern;
@property (nonatomic, assign, getter=isVerified) BOOL verified;

@end

@implementation ICPatternLockViewController

#pragma mark - Lifecycle
- (instancetype)initWithType:(ICPatternLockType)type
                successBlock:(void (^)(ICPatternLockViewController *lockVC))successBlock
              forgetPwdBlock:(void (^)(ICPatternLockViewController *lockVC))forgetPwdBlock
{
    if (self = [super init])
    {
        self.type = type;
        self.successBlock = successBlock;
        self.forgetPwdBlock = forgetPwdBlock;
        
        if(self.type == ICPatternLockTypeModify)
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ICLocalizedString(PL_RES_KEY_TEXT_CLOSE)
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(closeClicked:)];
        }
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = ICColor(PL_RES_KEY_COLOR_BACKGROUND);
    
    CGFloat viewWidth = CGRectGetWidth(view.bounds);
    CGFloat viewHeight = CGRectGetHeight(view.bounds);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+44, viewWidth, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [view addSubview:headerView];
    {
        ICPatternLockHintLabel *hintLabel = [[ICPatternLockHintLabel alloc] initWithFrame:CGRectMake(0,
                                                                                                     20,
                                                                                                     CGRectGetWidth(headerView.bounds),
                                                                                                     CGRectGetHeight(headerView.bounds))];
        hintLabel.backgroundColor = [UIColor clearColor];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.numberOfLines = 3;
        hintLabel.font = [UIFont systemFontOfSize:18.0f];
        [headerView addSubview:hintLabel];
        self.hintLabel = hintLabel;
    }
    
    CGFloat actionViewHeight = 40;
    if (ICPatternLockTypeVerify == self.type)
    {
        UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      viewHeight - actionViewHeight,
                                                                      viewWidth,
                                                                      actionViewHeight)];
        actionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        actionView.backgroundColor = [UIColor clearColor];
        [view addSubview:actionView];
        
        UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            viewWidth/2,
                                                                            CGRectGetHeight(actionView.bounds))];
        forgetButton.backgroundColor = [UIColor clearColor];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [forgetButton setTitle:ICLocalizedString(PL_RES_KEY_TEXT_ACTION_FORGET_PATTERN) forState:UIControlStateNormal];
        [forgetButton setTitleColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT) forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forgetClicked:) forControlEvents:UIControlEventTouchUpInside];
        [actionView addSubview:forgetButton];
        
        
        UIButton *modifyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(forgetButton.frame),
                                                                            0,
                                                                            viewWidth/2,
                                                                            CGRectGetHeight(actionView.bounds))];
        modifyButton.backgroundColor = [UIColor clearColor];
        modifyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [modifyButton setTitle:ICLocalizedString(PL_RES_KEY_TEXT_ACTION_MODIFY_PATTERN) forState:UIControlStateNormal];
        [modifyButton setTitleColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT) forState:UIControlStateNormal];
        [modifyButton addTarget:self action:@selector(modifyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [actionView addSubview:modifyButton];
    }
    
    ICPatternLockView *lockView = [[ICPatternLockView alloc] initWithFrame:CGRectMake(0,
                                                                                      CGRectGetMaxY(headerView.frame),
                                                                                      viewWidth,
                                                                                      viewHeight - CGRectGetMaxY(headerView.frame) - actionViewHeight)];
    lockView.backgroundColor = [UIColor clearColor];
    lockView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
#if 0
    lockView.nodeCount = [ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE) count];
    lockView.nodeCountPerRow = [ICPreferencesValue(PL_PFRS_KEY_NODE_COUNT_PER_ROW) intValue];
#endif
    [lockView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_NORMAL) forState:ICPatternLockNodeStateNormal];
    [lockView setNodeColor:ICColor(PL_RES_KEY_COLOR_CIRCLE_SELECTED) forState:ICPatternLockNodeStateSelected];
    [view addSubview:lockView];
    self.lockView = lockView;
    self.lockView.delegate = self;
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *msg = nil;
    if(self.type == ICPatternLockTypeSet)
    {
        msg = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET);
    }
    else if (self.type == ICPatternLockTypeVerify)
    {
        msg = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_PATTERN);
    }
    else if (self.type == ICPatternLockTypeModify)
    {
        msg = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN);
    }
    [self showNormalHintMessage:msg];
}

#pragma mark - Getters
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIBarButtonItem *)resetItem
{
    if(_resetItem == nil)
    {
        _resetItem = [[UIBarButtonItem alloc] initWithTitle:ICLocalizedString(PL_RES_KEY_TEXT_RESET)
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(resetClicked:)];
    }
    
    return _resetItem;
}

#pragma mark - Hint Message Display
- (void)showNormalHintMessage:(NSString *)message
{
    [self.hintLabel showHintMessage:message withTextColor:ICColor(PL_RES_KEY_COLOR_HINT_TEXT)];
}

- (void)showWarningHintMessage:(NSString *)message
{
    [self.hintLabel showHintMessage:message withTextColor:ICColor(PL_RES_KEY_COLOR_WARN_TEXT)];
    [self.hintLabel shake];
}

#pragma mark - GUI Callback
- (void)forgetClicked:(id)sender
{
    if(_forgetPwdBlock != nil) _forgetPwdBlock(self);
}

- (void)modifyClicked:(id)sender
{
    ICPatternLockViewController *lockVC = [[ICPatternLockViewController alloc] initWithType:ICPatternLockTypeModify successBlock:nil forgetPwdBlock:nil];
    lockVC.title = ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_PATTERN);
    lockVC.navigationItem.leftBarButtonItem = nil;

    [self.navigationController pushViewController:lockVC animated:YES];
}

- (void)closeClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetClicked:(id)sender
{
    [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET)];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.lockView resetPattern];
}

#pragma mark - ICPatternLockViewDelegate
- (BOOL)lockViewDidVerifyPattern:(ICPatternLockView *)lockView pattern:(NSString *)pattern
{
    BOOL res = [[ICPatternHandler sharedPatternHandler] verifypattern:pattern];
    
    if(res)
    {
        [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_SUCCEED)];
        
        if(self.type == ICPatternLockTypeVerify)
        {
            self.view.userInteractionEnabled = NO;
            
        }
        else if (self.type == ICPatternLockTypeModify)
        {
            [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET)];
        }
        
        if(self.type == ICPatternLockTypeVerify)
        {
            if(_successBlock != nil) _successBlock(self);
        }
        
    }
    else
    {
        [self showWarningHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_ERROR)];
    }
    
    return res;
}

// Fail
// Information will be stored in error.userInfo
- (void)lockView:(ICPatternLockView *)lockView failWithError:(NSError *)error
{
    if (error.code == ICPatternLockErrorNotEnoughNodes)
    {
        NSNumber *minNodeCount = ICPreferencesValue(PL_PFRS_KEY_MINIMUM_NODE_COUNT);
        [self showWarningHintMessage:[NSString stringWithFormat:ICLocalizedString(PL_RES_KEY_TEXT_PATTERN_TOO_SHORT), minNodeCount]];
    }
    else if (error.code == ICPatternLockErrorPatternsNotMatch)
    {
        [self showWarningHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SECOND_WRONG)];
        self.navigationItem.rightBarButtonItem = self.resetItem;
    }
}

- (void)patternLockViewTouchWillBegin:(ICPatternLockView *)lockView
{
    if(self.type == ICPatternLockTypeSet)
    {
        if(self.firstSetPattern == nil)
        {
            [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET)];
        }
        else
        {
            [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_CONFIRM_SET)];
        }
    }
    else if(self.type == ICPatternLockTypeVerify)
    {
        [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_VERIFY_PATTERN)];
    }
    else if (self.type == ICPatternLockTypeModify)
    {
        NSString *msg = [self isVerified] ? ICLocalizedString(PL_RES_KEY_TEXT_TITLE_FIRST_SET) : ICLocalizedString(PL_RES_KEY_TEXT_TITLE_MODIFY_INPUT_OLD_PATTERN);
        [self showNormalHintMessage:msg];
    }
}

- (void)patternLockViewTouchDidEnd:(ICPatternLockView *)lockView selectedIndexes:(NSArray *)selectedIndexes
{
    NSUInteger count = [selectedIndexes count];
    
    NSNumber *minNodeCountNum = ICPreferencesValue(PL_PFRS_KEY_MINIMUM_NODE_COUNT);
    NSUInteger minNodeCount = [minNodeCountNum unsignedIntegerValue];
    
    if(count < minNodeCount)
    {
        NSError *error = [NSError errorWithDomain:ICPATTERNLOCK_ERROR_DOMAIN
                                             code:ICPatternLockErrorNotEnoughNodes
                                         userInfo:@{ICPATTERNLOCK_ERROR_KEY_NODE_COUNT:@(count)}];
        [self lockView:lockView failWithError:error];
    }
    else
    {
        NSArray *decryptTable = ICPreferencesValue(PL_PFRS_KEY_NODE_TABLE);
        NSMutableString *parrtenStr = [NSMutableString string];
        for (NSNumber *index in selectedIndexes)
        {
            [parrtenStr appendString:decryptTable[[index intValue]]];
        }
        
        if(self.type == ICPatternLockTypeSet)
        {
            [self updatePattern:parrtenStr];
        }
        else if(self.type == ICPatternLockTypeVerify)
        {
            self.verified = [self lockViewDidVerifyPattern:lockView pattern:parrtenStr];
        }
        else if (self.type == ICPatternLockTypeModify)
        {
            if(![self isVerified])
            {
                self.verified = [self lockViewDidVerifyPattern:lockView pattern:parrtenStr];
            }
            else
            {
                [self updatePattern:parrtenStr];
            }
        }
    }
}

- (void)updatePattern:(NSString *)patternString
{
    if(self.firstSetPattern == nil)
    {
        self.firstSetPattern = patternString;
        [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_CONFIRM_SET)];
    }
    else
    {
        if(![self.firstSetPattern isEqualToString:patternString])
        {
            NSError *error = [NSError errorWithDomain:ICPATTERNLOCK_ERROR_DOMAIN code:ICPatternLockErrorPatternsNotMatch userInfo:nil];
            [self lockView:nil failWithError:error];
        }
        else
        {
            [self showNormalHintMessage:ICLocalizedString(PL_RES_KEY_TEXT_TITLE_SET_SUCCEED)];
            
            [[ICPatternHandler sharedPatternHandler] setPattern:patternString];
            
            self.view.userInteractionEnabled = NO;
            
            if(_successBlock != nil) _successBlock(self);
            
            if(ICPatternLockTypeModify == _type)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    }
    
}
@end
