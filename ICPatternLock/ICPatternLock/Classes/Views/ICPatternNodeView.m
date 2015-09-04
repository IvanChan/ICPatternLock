//
//  ICPatternNodeView.m
//  ICPatternLock
//
//  Created by _ivanC on 8/27/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternNodeView.h"

@interface ICPatternNodeView ()

@property (nonatomic, assign) CGRect ringRect;
@property (nonatomic, assign) CGRect selectedSolidCircleRect;

@property (nonatomic, strong) UIColor *nodeColorNormal;
@property (nonatomic, strong) UIColor *nodeColorSelected;

@end

@implementation ICPatternNodeView

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    
        self.nodeColorNormal = [UIColor whiteColor];
        self.nodeColorSelected = [UIColor blueColor];
        
        self.lineWidth = 1;
        self.solidCircleScale = 0.3f;
    }
    
    return self;
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self applyDrawAttributes:context];
    
    [self drawRing:context inRect:rect];
    
    if ([self isSelected])
    {
        [self drawSolidCircle:context inRect:rect];
        
        [self applyRotationForDirect:context rect:rect];

        [self drawDirectionArrow:context inRect:rect];
    }
}

- (void)applyDrawAttributes:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.lineWidth);
    
    UIColor *color = [self isSelected] ? self.nodeColorSelected : self.nodeColorNormal;
    [color set];
}

- (void)applyRotationForDirect:(CGContextRef)context rect:(CGRect)rect
{
    if (![self isAngleCalculated])
    {
        return;
    }
    
    CGFloat translateXY = rect.size.width/2.0f;
    
    // Move to center of circle
    CGContextTranslateCTM(context, translateXY, translateXY);
    
    // Rotate context in order to draw direction arrow
    CGContextRotateCTM(context, self.arrowAngle);
    
    // Move back
    CGContextTranslateCTM(context, -translateXY, -translateXY);
}

- (void)drawRing:(CGContextRef)context inRect:(CGRect)rect
{
    CGMutablePathRef loopPath = CGPathCreateMutable();
    
    CGRect ringRect = self.ringRect;
    CGPathAddEllipseInRect(loopPath, NULL, ringRect);
    
    CGContextAddPath(context, loopPath);
    CGContextStrokePath(context);
    
    CGPathRelease(loopPath);
}

- (void)drawSolidCircle:(CGContextRef)context inRect:(CGRect)rect
{
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    CGPathAddEllipseInRect(circlePath, NULL, self.selectedSolidCircleRect);
    
    [self.nodeColorSelected set];
    
    CGContextAddPath(context, circlePath);
    CGContextFillPath(context);
    CGPathRelease(circlePath);
}

- (void)drawDirectionArrow:(CGContextRef)context inRect:(CGRect)rect
{
    if (![self isAngleCalculated])
    {
        return;
    }
    
    CGMutablePathRef trianglePathM = CGPathCreateMutable();
    
    // Calculate 3 points
    CGFloat marginSelectedCirclev = 4.0f;
    CGFloat w = 8.0f;
    CGFloat h = 5.0f;
    CGFloat topX = rect.origin.x + rect.size.width/2.0f;
    CGFloat topY = rect.origin.y + (rect.size.width/2.0f - h - marginSelectedCirclev - self.selectedSolidCircleRect.size.height/2.0f);
    
    CGPathMoveToPoint(trianglePathM, NULL, topX, topY);
    
    // Draw 2 lines connecting to ring
    CGFloat leftPointX = topX - w *.5f;
    CGFloat leftPointY =topY + h;
    CGPathAddLineToPoint(trianglePathM, NULL, leftPointX, leftPointY);
    
    CGFloat rightPointX = topX + w *.5f;
    CGPathAddLineToPoint(trianglePathM, NULL, rightPointX, leftPointY);

    CGContextAddPath(context, trianglePathM);
    CGContextFillPath(context);
    
    CGPathRelease(trianglePathM);
}

#pragma mark - Getters & Setters
- (void)setSelected:(BOOL)selected
{
    if (_selected == selected)
    {
        return;
    }
    
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setArrowAngle:(CGFloat)arrowAngle
{
    if (_arrowAngle == arrowAngle)
    {
        return;
    }
        
    _arrowAngle = arrowAngle;
    [self setNeedsDisplay];
}

- (void)setNodeColor:(UIColor *)nodeColor forState:(ICPatternLockNodeState)state
{
    if (state == ICPatternLockNodeStateNormal)
    {
        self.nodeColorNormal = nodeColor;
    }
    else if (state == ICPatternLockNodeStateSelected)
    {
        self.nodeColorSelected = nodeColor;
    }
    
    [self setNeedsDisplay];
}

- (UIColor *)nodeColorForState:(ICPatternLockNodeState)state
{
    UIColor *color = nil;
    if (state == ICPatternLockNodeStateNormal)
    {
        color = self.nodeColorNormal;
    }
    else if (state == ICPatternLockNodeStateSelected)
    {
        color = self.nodeColorSelected;
    }
    return color;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if (_lineWidth == lineWidth)
    {
        return;
    }
    
    _lineWidth = lineWidth;

    [self recalculateRingRect];
    
    [self setNeedsDisplay];
}

- (void)setSolidCircleScale:(CGFloat)solidCircleScale
{
    if (_solidCircleScale == solidCircleScale)
    {
        return;
    }
    
    _solidCircleScale = solidCircleScale;
    
    [self recalculateSolidCircleRect];
    
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self recalculateRingRect];
    [self recalculateSolidCircleRect];
}

- (void)recalculateRingRect
{
    CGFloat sizeWH = self.bounds.size.width - _lineWidth;
    CGFloat originXY = _lineWidth/2.0f;
    
    _ringRect = (CGRect){CGPointMake(originXY, originXY), CGSizeMake(sizeWH, sizeWH)};
}

- (void)recalculateSolidCircleRect
{
    CGRect rect = self.bounds;
    
    CGFloat selectRectWH = rect.size.width * _solidCircleScale;
    
    CGFloat selectRectXY = rect.size.width * (1 - _solidCircleScale) / 2.0f;
    
    _selectedSolidCircleRect = CGRectMake(selectRectXY, selectRectXY, selectRectWH, selectRectWH);
}
@end
