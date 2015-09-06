//
//  ICPatternLockDef.h
//  ICPatternLock
//
//  Created by _ivanC on 8/27/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#ifndef ICPatternLock_ICPatternLockDef_h
#define ICPatternLock_ICPatternLockDef_h

/////////////////////// Error ///////////////////////////////////////////
typedef NS_ENUM(NSUInteger, ICPatternLockError) {
    ICPatternLockErrorNone = 0,
    ICPatternLockErrorNotEnoughNodes,
    ICPatternLockErrorPatternsNotMatch,
    ICPatternLockErrorVerifyPatternFail,
    ICPatternLockErrorUpdatePatternFail,
};

#define ICPATTERNLOCK_ERROR_DOMAIN          @"ICPatternLockErrorDomain"
#define ICPATTERNLOCK_ERROR_KEY_NODE_COUNT  @"count"

//////////////////////////////////////////////////////////////////

#endif
