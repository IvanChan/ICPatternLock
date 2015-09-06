//
//  ICPatternLockViewController.h
//  ICPatternLock
//
//  Created by _ivanC on 15/8/28.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ICPatternLockType) {
    ICPatternLockTypeSet = 0,
    ICPatternLockTypeVerify,
    ICPatternLockTypeModify,
};

typedef NS_ENUM(NSUInteger, ICPatternLockState) {
    ICPatternLockStateNone = 0,
    ICPatternLockStateFirstPatternSetted,
    ICPatternLockStateSecondPatternConfirmed,
    ICPatternLockStatePatternVerified,
};

@protocol ICPatternLockViewControllerDelegate;
@protocol ICPatternLockViewControllerDataSource;
@class ICPatternLockView;
@interface ICPatternLockViewController : UIViewController

@property (nonatomic, weak) id<ICPatternLockViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<ICPatternLockViewControllerDelegate> delegate;

@property (nonatomic, assign, readonly) ICPatternLockType type;
@property (nonatomic, assign, readonly) ICPatternLockState state;

@property (nonatomic, assign) NSUInteger minimumNodeForPattern;     // Default is 4

@property (nonatomic, strong, readonly) ICPatternLockView *patternView;
@property (nonatomic, strong, readonly) UIView *actionView;
@property (nonatomic, strong, readonly) UIButton *forgotButton;
@property (nonatomic, strong, readonly) UIButton *modifyButton;

@property (nonatomic, strong, readonly) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *resetBarButtonItem;

- (instancetype)initWithType:(ICPatternLockType)type;

- (void)showHintMessage:(NSString *)message withTextColor:(UIColor *)color shake:(BOOL)shake;

- (void)resetPattern;

@end

@protocol ICPatternLockViewControllerDataSource <NSObject>

- (NSString *)hintMessageForState:(ICPatternLockState)state;

- (BOOL)patternLockViewController:(ICPatternLockViewController *)patternLockViewController verifyPattern:(NSString *)pattern;
- (BOOL)patternLockViewController:(ICPatternLockViewController *)patternLockViewController updatePattern:(NSString *)pattern;

@end

@protocol ICPatternLockViewControllerDelegate <NSObject>

// For showing hint message for different state
- (void)patternLockViewControllerWillStartDrawPattern:(ICPatternLockViewController *)patternLockViewController;

- (void)patternLockViewControllerPatternVerified:(ICPatternLockViewController *)patternLockViewController;
- (void)patternLockViewControllerPatternUpdated:(ICPatternLockViewController *)patternLockViewController;

// Information will be stored in error.userInfo
- (void)patternLockViewController:(ICPatternLockViewController *)patternLockViewController failWithError:(NSError *)error;

@optional
- (void)patternLockViewControllerForgotClicked:(ICPatternLockViewController *)patternLockViewController;
- (void)patternLockViewControllerModifyClicked:(ICPatternLockViewController *)patternLockViewController;
- (void)patternLockViewControllerResetClicked:(ICPatternLockViewController *)patternLockViewController;
- (void)patternLockViewControllerCloseClicked:(ICPatternLockViewController *)patternLockViewController;

@end