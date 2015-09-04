//
//  ICPatternNodeView.h
//  ICPatternLock
//
//  Created by _ivanC on 8/27/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ICPatternLockNodeState) {
    ICPatternLockNodeNone = 0,
    ICPatternLockNodeStateNormal,
    ICPatternLockNodeStateSelected,
};

@interface ICPatternNodeView : UIView

@property (nonatomic, assign) NSUInteger nodeIndex;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) CGFloat arrowAngle;
@property (nonatomic, assign, getter=isAngleCalculated) BOOL angleCalculated;

@property (nonatomic, assign) CGFloat lineWidth;            // Default is 1
@property (nonatomic, assign) CGFloat solidCircleScale;     // Default is 0.3

- (void)setNodeColor:(UIColor *)nodeColor forState:(ICPatternLockNodeState)state;
- (UIColor *)nodeColorForState:(ICPatternLockNodeState)state;

@end
