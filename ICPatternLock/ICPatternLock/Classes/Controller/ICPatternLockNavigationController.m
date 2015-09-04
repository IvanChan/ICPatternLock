//
//  ICPatternLockNavigationController.m
//  ICPatternLock
//
//  Created by _ivanC on 8/27/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternLockNavigationController.h"
#import "ICResourceBridge.h"

@implementation ICPatternLockNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:ICColor(PL_RES_KEY_COLOR_NAVI_TEXT),
                                                 NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
