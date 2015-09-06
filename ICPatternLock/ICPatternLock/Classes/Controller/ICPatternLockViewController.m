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

@interface ICPatternLockViewController () <ICPatternLockViewDelegate>

@property (nonatomic, assign) ICPatternLockType type;
@property (nonatomic, assign) ICPatternLockState state;

@property (nonatomic, strong) ICPatternLockHintLabel *hintLabel;
@property (nonatomic, strong) ICPatternLockView *patternView;
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIButton *forgotButton;
@property (nonatomic, strong) UIButton *modifyButton;

@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *resetBarButtonItem;

@property (nonatomic, copy) NSString *firstSetPattern;

@end

@implementation ICPatternLockViewController

#pragma mark - Lifecycle
- (instancetype)initWithType:(ICPatternLockType)type
{
    if (self = [super init])
    {
        self.type = type;
        self.minimumNodeForPattern = 4;
        
        if(self.type == ICPatternLockTypeModify)
        {
            self.navigationItem.leftBarButtonItem = self.closeBarButtonItem;
        }
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor brownColor];
    
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
    if (self.type == ICPatternLockTypeVerify)
    {
        UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      viewHeight - actionViewHeight,
                                                                      viewWidth,
                                                                      actionViewHeight)];
        actionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        actionView.backgroundColor = [UIColor clearColor];
        [view addSubview:actionView];
        self.actionView = actionView;
        
        UIButton *forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            viewWidth/2,
                                                                            CGRectGetHeight(actionView.bounds))];
        forgotButton.backgroundColor = [UIColor clearColor];
        forgotButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [forgotButton setTitle:@"Forgot" forState:UIControlStateNormal];
        [forgotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgotButton addTarget:self action:@selector(forgotClicked:) forControlEvents:UIControlEventTouchUpInside];
        [actionView addSubview:forgotButton];
        self.forgotButton = forgotButton;
        
        UIButton *modifyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(forgotButton.frame),
                                                                            0,
                                                                            viewWidth/2,
                                                                            CGRectGetHeight(actionView.bounds))];
        modifyButton.backgroundColor = [UIColor clearColor];
        modifyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [modifyButton setTitle:@"Modify" forState:UIControlStateNormal];
        [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [modifyButton addTarget:self action:@selector(modifyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [actionView addSubview:modifyButton];
        self.modifyButton = modifyButton;
    }
    
    ICPatternLockView *lockView = [[ICPatternLockView alloc] initWithFrame:CGRectMake(0,
                                                                                      CGRectGetMaxY(headerView.frame),
                                                                                      viewWidth,
                                                                                      viewHeight - CGRectGetMaxY(headerView.frame) - actionViewHeight)];
    lockView.backgroundColor = [UIColor clearColor];
    lockView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [view addSubview:lockView];
    self.patternView = lockView;
    self.patternView.delegate = self;
    
    self.view = view;
}

#pragma mark - Getters
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIBarButtonItem *)resetBarButtonItem
{
    if (_resetBarButtonItem == nil)
    {
        _resetBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(resetClicked:)];
    }
    return _resetBarButtonItem;
}

- (UIBarButtonItem *)closeBarButtonItem
{
    if (_closeBarButtonItem == nil)
    {
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(closeClicked:)];
    }
    return _closeBarButtonItem;
}

#pragma mark - Hint Message Display
- (void)showHintMessage:(NSString *)message withTextColor:(UIColor *)color shake:(BOOL)shake
{
    [self.hintLabel showHintMessage:message withTextColor:color];
    if (shake)
    {
        [self.hintLabel shake];
    }
}

#pragma mark -
- (void)resetPattern
{
    self.firstSetPattern = nil;
    self.state = ICPatternLockStateNone; // TODO:
}

#pragma mark - GUI Callback
- (void)forgotClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(patternLockViewControllerForgotClicked:)])
    {
        [self.delegate patternLockViewControllerForgotClicked:self];
    }
}

- (void)modifyClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(patternLockViewControllerModifyClicked:)])
    {
        [self.delegate patternLockViewControllerModifyClicked:self];
    }
}

- (void)closeClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(patternLockViewControllerCloseClicked:)])
    {
        [self.delegate patternLockViewControllerCloseClicked:self];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)resetClicked:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    [self resetPattern];

    if ([self.delegate respondsToSelector:@selector(patternLockViewControllerResetClicked:)])
    {
        [self.delegate patternLockViewControllerResetClicked:self];
    }
}

#pragma mark - ICPatternLockViewDelegate
- (BOOL)verifyPattern:(NSString *)pattern
{
    BOOL res = [self.dataSource patternLockViewController:self verifyPattern:pattern];
    if(res)
    {
        [self.delegate patternLockViewControllerPatternVerified:self];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:ICPATTERNLOCK_ERROR_DOMAIN
                                             code:ICPatternLockErrorVerifyPatternFail
                                         userInfo:nil];
        [self.delegate patternLockViewController:self failWithError:error];
        
    }
    
    return res;
}

- (void)patternLockViewTouchWillBegin:(ICPatternLockView *)lockView
{
    [self.delegate patternLockViewControllerWillStartDrawPattern:self];
}

- (void)patternLockViewTouchDidEnd:(ICPatternLockView *)lockView selectedIndexes:(NSArray *)selectedIndexes
{
    NSUInteger count = [selectedIndexes count];
    if(count < self.minimumNodeForPattern)
    {
        NSError *error = [NSError errorWithDomain:ICPATTERNLOCK_ERROR_DOMAIN
                                             code:ICPatternLockErrorNotEnoughNodes
                                         userInfo:@{ICPATTERNLOCK_ERROR_KEY_NODE_COUNT:@(count)}];
        [self.delegate patternLockViewController:self failWithError:error];
    }
    else
    {
        NSString *parrtenStr = [selectedIndexes componentsJoinedByString:@""];
        if(self.type == ICPatternLockTypeSet)
        {
            [self updatePattern:parrtenStr];
        }
        else if(self.type == ICPatternLockTypeVerify)
        {
            if( [self verifyPattern:parrtenStr])
            {
                self.state = ICPatternLockStatePatternVerified;
            }
        }
        else if (self.type == ICPatternLockTypeModify)
        {
            if(self.state != ICPatternLockStatePatternVerified)
            {
                if( [self verifyPattern:parrtenStr])
                {
                    self.state = ICPatternLockStatePatternVerified;
                }
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
        self.state = ICPatternLockStateFirstPatternSetted;
        [self.delegate patternLockViewControllerPatternUpdated:self];
    }
    else
    {
        if(![self.firstSetPattern isEqualToString:patternString])
        {
            NSError *error = [NSError errorWithDomain:ICPATTERNLOCK_ERROR_DOMAIN code:ICPatternLockErrorPatternsNotMatch userInfo:nil];
            [self.delegate patternLockViewController:self failWithError:error];
            
            self.navigationItem.rightBarButtonItem = self.resetBarButtonItem;
        }
        else
        {
            self.state = ICPatternLockStateSecondPatternConfirmed;
            
            if ([self.dataSource patternLockViewController:self updatePattern:patternString])
            {
                [self.delegate patternLockViewControllerPatternUpdated:self];
            }
            else
            {
                NSError *error = [NSError errorWithDomain:ICPATTERNLOCK_ERROR_DOMAIN
                                                     code:ICPatternLockErrorUpdatePatternFail
                                                 userInfo:nil];
                [self.delegate patternLockViewController:self failWithError:error];
            }
        }
    }
    
}

@end
