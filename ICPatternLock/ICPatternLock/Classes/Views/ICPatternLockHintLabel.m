//
//  ICPatternLockHintLabel.m
//  ICPatternLock
//
//  Created by _ivanC on 15/8/27.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternLockHintLabel.h"

@implementation ICPatternLockHintLabel

#pragma mark - Hint Message Display
- (void)showHintMessage:(NSString *)message withTextColor:(UIColor *)textColor
{
    self.textColor = textColor;
    self.text = message;
}

#pragma mark - Animation
- (void)shake
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 16;
    animation.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    animation.duration = .1f;
    animation.repeatCount =2;
    animation.removedOnCompletion = YES;
    
    [self.layer addAnimation:animation forKey:@"shake"];
}

@end
