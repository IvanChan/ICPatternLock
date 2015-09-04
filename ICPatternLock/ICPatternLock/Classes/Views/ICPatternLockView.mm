//
//  ICPatternLockView.m
//  ICPatternLock
//
//  Created by _ivanC on 15/8/28.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import "ICPatternLockView.h"
#import "ICPatternNodeView.h"
#import <math.h>

@interface ICPatternLockView ()

@property (nonatomic, strong) NSMutableArray *allNodes;
@property (nonatomic, strong) NSMutableArray *selectedNodes;

@end

@implementation ICPatternLockView
@synthesize nodeCount = _nodeCount;
@synthesize nodeCountPerRow = _nodeCountPerRow;
@synthesize nodeMargin = _nodeMargin;

#pragma mark - Getters
- (NSMutableArray *)allNodes
{
    if (_allNodes == nil)
    {
        _allNodes = [[NSMutableArray alloc] initWithCapacity:9];
    }
    return _allNodes;
}

- (NSMutableArray *)selectedNodes
{
    if(_selectedNodes == nil)
    {
        _selectedNodes = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _selectedNodes;
}

- (CGFloat)nodeMargin
{
    if (_nodeMargin <= 0)
    {
        _nodeMargin = 34.0f;
    }
    
    return _nodeMargin;
}

- (NSUInteger)nodeCount
{
    if (_nodeCount <= 0)
    {
        _nodeCount = 9;
    }
    
    return _nodeCount;
}

- (NSUInteger)nodeCountPerRow
{
    if (_nodeCountPerRow <= 0)
    {
        _nodeCountPerRow = 3;
    }
    
    return _nodeCountPerRow;
}

#pragma mark - Setters
- (void)setNodeCount:(NSUInteger)nodeCount
{
    if (_nodeCount == nodeCount)
    {
        return;
    }
    
    _nodeCount = nodeCount;
    
    [self.allNodes makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.allNodes removeAllObjects];
    [self.selectedNodes removeAllObjects];
    
    for (NSUInteger i = 0; i < _nodeCount; i++)
    {
        ICPatternNodeView *nodeView = [[ICPatternNodeView alloc] init];
        
        [self addSubview:nodeView];
        [self.allNodes addObject:nodeView];
    }
    
    [self setNeedsLayout];
}

- (void)setNodeCountPerRow:(NSUInteger)nodeCountPerRow
{
    if (_nodeCountPerRow == nodeCountPerRow)
    {
        return;
    }
    
    _nodeCountPerRow = nodeCountPerRow;

    [self setNeedsLayout];
}

- (void)setNodeMargin:(CGFloat)nodeMargin
{
    if (_nodeMargin == nodeMargin)
    {
        return;
    }
    
    _nodeMargin = nodeMargin;
    
    [self setNeedsLayout];
}

- (void)setNodeColor:(UIColor *)nodeColor forState:(ICPatternLockNodeState)state
{
    [self.allNodes enumerateObjectsUsingBlock:^(ICPatternNodeView *nodeView, NSUInteger index, BOOL *stop) {
        
        [nodeView setNodeColor:nodeColor forState:state];
    }];
    
    [self setNeedsDisplay];
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
    if([self.selectedNodes count] <= 0)
    {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Clip, only draw line between nodes
    {
        CGContextAddRect(context, rect);
        
        [self.selectedNodes enumerateObjectsUsingBlock:^(ICPatternNodeView *nodeView, NSUInteger idx, BOOL *stop) {
            
            CGContextAddEllipseInRect(context, nodeView.frame);
        }];
        
        CGContextEOClip(context);
    }
    
    // Create pattern path
    CGMutablePathRef patternPath = CGPathCreateMutable();

    // Color set
    ICPatternNodeView *node = self.selectedNodes[0];
    [[node nodeColorForState:ICPatternLockNodeStateSelected] set];
    
    // Apply line property
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 1.0f);
    
    // Draw the pattern
    [self.selectedNodes enumerateObjectsUsingBlock:^(ICPatternNodeView *nodeView, NSUInteger idx, BOOL *stop) {
        
        CGPoint directPoint = nodeView.center;
        if(idx == 0)
        {
            CGPathMoveToPoint(patternPath, NULL, directPoint.x, directPoint.y);
        }
        else
        {
            CGPathAddLineToPoint(patternPath, NULL, directPoint.x, directPoint.y);
        }
    }];

    CGContextAddPath(context, patternPath);
    CGContextStrokePath(context);
    
    CGPathRelease(patternPath);
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger nodeCountInLine = self.nodeCountPerRow;
    CGFloat nodeViewWH = (self.frame.size.width - (nodeCountInLine + 1) * self.nodeMargin) / (float)nodeCountInLine;

    [self.allNodes enumerateObjectsUsingBlock:^(ICPatternNodeView *subview, NSUInteger index, BOOL *stop) {
        
            NSUInteger row = index % nodeCountInLine;
            
            NSUInteger col = index / nodeCountInLine;
            
            CGFloat x = self.nodeMargin * (row +1) + row * nodeViewWH;
            
            CGFloat y = self.nodeMargin * (col +1) + col * nodeViewWH;
            
            CGRect frame = CGRectMake(x, y, nodeViewWH, nodeViewWH);
        
            subview.frame = frame;
    }];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate patternLockViewTouchWillBegin:self];

    [self updateNodesStatus:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateNodesStatus:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self gestureEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self gestureEnd];
}

- (void)gestureEnd
{
    if([self.selectedNodes count] <= 0)
    {
        return;
    }

    // Reset
    NSUInteger count = [self.selectedNodes count];
    NSMutableArray *selectedIndexes = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        ICPatternNodeView *nodeView = self.selectedNodes[i];
        nodeView.selected = NO;
        nodeView.angleCalculated = NO;
        [selectedIndexes addObject:@([self.allNodes indexOfObject:nodeView])];
    }
    [self.delegate patternLockViewTouchDidEnd:self selectedIndexes:selectedIndexes];

    
    [self.selectedNodes removeAllObjects];

    [self setNeedsDisplay];
}

#pragma mark - Update nodes
- (ICPatternNodeView *)nodeViewinTouchLocation:(CGPoint)location
{
    ICPatternNodeView *targetNodeView = nil;
    
    for (ICPatternNodeView *nodeView in self.allNodes)
    {
        if(CGRectContainsPoint(nodeView.frame, location))
        {
            targetNodeView = nodeView;
            break;
        }
    }
    
    return targetNodeView;
}

- (void)updateNodesStatus:(NSSet *)touches
{
    // Touch location
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    ICPatternNodeView *nodeView = [self nodeViewinTouchLocation:location];
    if(nodeView)
    {
        if (![self.selectedNodes containsObject:nodeView])
        {
            // find new node in touch
            [self.selectedNodes addObject:nodeView];
            
            // calculate the direct of arrow
            [self calculateDirect];
            
            // select this node
            nodeView.selected = YES;
            [self setNeedsDisplay];
        }
    }
}

- (void)calculateDirect
{
    NSUInteger count = [self.selectedNodes count];
    if (count <= 1)
    {
        return;
    }
    
    ICPatternNodeView *last_1_nodeView = [self.selectedNodes lastObject];
    ICPatternNodeView *last_2_nodeView = self.selectedNodes[count -2];
    
    CGPoint last_1_center = last_1_nodeView.center;
    CGPoint last_2_center = last_2_nodeView.center;
    
    CGFloat xLen = fabsf(last_1_center.x - last_2_center.x);
    CGFloat yLen = fabsf(last_1_center.y - last_2_center.y);

    CGFloat angle = 0;
    if (yLen < 0.001)
    {
        angle = last_1_center.x > last_2_center.x ? M_PI_2 : -M_PI_2;
    }
    else if (xLen < 0.001)
    {
        angle = last_1_center.y > last_2_center.y ? M_PI : 0;
    }
    else
    {
        if (last_1_center.x > last_2_center.x && last_1_center.y < last_2_center.y)
        {
            // First quadrant
            angle = atanf(xLen/yLen);
        }
        else if (last_1_center.x > last_2_center.x && last_1_center.y > last_2_center.y)
        {
            // Second quadrant
            angle = -atanf(xLen/yLen) - M_PI;
        }
        else if (last_1_center.x < last_2_center.x && last_1_center.y > last_2_center.y)
        {
            // Third quadrant
            angle = atanf(xLen/yLen) + M_PI;
        }
        else if (last_1_center.x < last_2_center.x && last_1_center.y < last_2_center.y)
        {
            // Fourth quadrant
            angle = -atanf(xLen/yLen);
        }
    }
    
    last_2_nodeView.angleCalculated = YES;
    last_2_nodeView.arrowAngle = angle;
}

#pragma mark - Reset
- (void)resetPattern
{
    [self.selectedNodes removeAllObjects];
}

@end
