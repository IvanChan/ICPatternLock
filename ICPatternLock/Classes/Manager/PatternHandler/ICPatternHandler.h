//
//  ICPatternHandler.h
//  ICPatternLock
//
//  Created by _ivanC on 8/22/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICPatternHandlerProtocol.h"

@interface ICPatternHandler : NSObject <ICPatternHandlerProtocol>

+ (instancetype)sharedPatternHandler;

+ (void)setCustomizedHandler:(id<ICPatternHandlerProtocol>)customizedHandler;

@end
