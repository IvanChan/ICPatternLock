//
//  ICViewController.m
//  ICPatternLock
//
//  Created by aintivanc@icloud.com on 04/23/2017.
//  Copyright (c) 2017 aintivanc@icloud.com. All rights reserved.
//

#import "ICViewController.h"
#import <ICPatternLock/ICPatternLock.h>

@interface ICViewController ()

@end

@implementation ICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat buttonWidth = 200;
    CGFloat buttonHeight = 50;
    
    UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - buttonWidth)/2,
                                                                     100,
                                                                     buttonWidth,
                                                                     buttonHeight)];
    [setButton setTitle:@"Set Pattern" forState:UIControlStateNormal];
    [setButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
    UIButton *verifyButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - buttonWidth)/2,
                                                                        CGRectGetMaxY(setButton.frame) + 50,
                                                                        buttonWidth,
                                                                        buttonHeight)];
    [verifyButton setTitle:@"Verify Pattern" forState:UIControlStateNormal];
    [verifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [verifyButton addTarget:self action:@selector(verifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verifyButton];
    
    UIButton *modifyButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - buttonWidth)/2,
                                                                        CGRectGetMaxY(verifyButton.frame) + 50,
                                                                        buttonWidth,
                                                                        buttonHeight)];
    [modifyButton setTitle:@"Modify Pattern" forState:UIControlStateNormal];
    [modifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modifyButton addTarget:self action:@selector(modifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyButton];
}

#pragma mark - Callbacks
- (void)setButtonClicked:(UIButton *)sender
{
    if ([ICPatternLockManager isPatternSetted])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                        message:@"Pattern already setted"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [ICPatternLockManager showSettingPatternLock:self
                                            animated:YES
                                        successBlock:^(ICPatternLockViewController *controller){
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [controller dismissViewControllerAnimated:YES completion:nil];
                                            });
                                        }];
    }
}

- (void)verifyButtonClicked:(UIButton *)sender
{
    if (![ICPatternLockManager isPatternSetted])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                        message:@"Set Pattern first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [ICPatternLockManager showVerifyPatternLock:self
                                           animated:YES
                                     forgetPwdBlock:^(ICPatternLockViewController *controller){
                                         
                                         NSLog(@"OMG~ forgot my pattern!~");
                                     }
                                       successBlock:^(ICPatternLockViewController *controller){
                                           
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               
                                               [controller dismissViewControllerAnimated:YES completion:nil];
                                           });
                                       }];
    }
}

- (void)modifyButtonClicked:(UIButton *)sender
{
    if (![ICPatternLockManager isPatternSetted])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                        message:@"Set Pattern first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [ICPatternLockManager showModifyPatternLock:self
                                           animated:YES
                                       successBlock:^(ICPatternLockViewController *controller) {
                                           
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               
                                               [controller dismissViewControllerAnimated:YES completion:nil];
                                           });
                                           
                                       }];
    }
}

@end
