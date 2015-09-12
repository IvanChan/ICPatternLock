//
//  ICPatternHandlerProtocol.h
//  ICPatternLock
//
//  Created by _ivanC on 8/22/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICPatternHandlerProtocol <NSObject>

- (BOOL)isPatternSetted;

- (BOOL)updatePattern:(NSString *)pattern;
- (BOOL)verifypattern:(NSString *)pattern;

@end