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

@interface ICPatternLockViewController : UIViewController

- (instancetype)initWithType:(ICPatternLockType)type
                successBlock:(void (^)(ICPatternLockViewController *lockVC))successBlock
              forgetPwdBlock:(void (^)(ICPatternLockViewController *lockVC))forgetPwdBlock;

@end
