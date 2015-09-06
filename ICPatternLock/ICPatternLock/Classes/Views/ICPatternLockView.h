//
//  ICPatternLockView.h
//  ICPatternLock
//
//  Created by _ivanC on 15/8/28.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICPatternNodeView.h"

@protocol ICPatternLockViewDelegate;
@interface ICPatternLockView : UIView

@property (nonatomic, assign) NSUInteger    nodeCount;         // Defailt is 9
@property (nonatomic, assign) NSUInteger    nodeCountPerRow;   // Default is 3
@property (nonatomic, assign) CGFloat       nodeMargin;        // Default to 34.0f

@property (nonatomic, weak) id<ICPatternLockViewDelegate> delegate;

- (void)setNodeColor:(UIColor *)nodeColor forState:(ICPatternLockNodeState)state;

@end

@protocol ICPatternLockViewDelegate <NSObject>

- (void)patternLockViewTouchWillBegin:(ICPatternLockView *)lockView;
- (void)patternLockViewTouchDidEnd:(ICPatternLockView *)lockView selectedIndexes:(NSArray *)selectedIndexes;


@end
