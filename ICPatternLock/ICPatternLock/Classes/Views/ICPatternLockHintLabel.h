//
//  ICPatternLockHintLabel.h
//  ICPatternLock
//
//  Created by _ivanC on 15/8/27.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICPatternLockHintLabel : UILabel

- (void)showHintMessage:(NSString *)message withTextColor:(UIColor *)textColor;
- (void)shake;

@end
