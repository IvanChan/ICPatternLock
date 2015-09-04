//
//  PLPreferencesKeyDef.h
//  ICPatternLock
//
//  Created by _ivanC on 8/23/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#ifndef ICPatternLock_PLPreferencesKeyDef_h
#define ICPatternLock_PLPreferencesKeyDef_h

//////////////////////////// Key ////////////////////////////////////////////
// Center solid circle / Outsiode ring circle
#define PL_PFRS_KEY_CENTER_SOLID_CIRCLE_SCALE       @"PL_PFRS_KEY_CENTER_SOLID_CIRCLE_SCALE"

// Outside ring line width
#define PL_PFRS_KEY_RING_LINE_WIDTH                 @"PL_PFRS_KEY_RING_LINE_WIDTH"

// Node count per row
#define PL_PFRS_KEY_NODE_COUNT_PER_ROW              @"PL_PFRS_KEY_NODE_COUNT_PER_ROW"

// Minimum node count
#define PL_PFRS_KEY_MINIMUM_NODE_COUNT              @"PL_PFRS_KEY_MINIMUM_NODE_COUNT"

// Node Table, element count decide node count
#define PL_PFRS_KEY_NODE_TABLE                      @"PL_PFRS_KEY_NODE_TABLE"

////////////////////////////// Default Value //////////////////////////////////////////
#define PL_PFRS_DEFAULT_CENTER_SOLID_CIRCLE_SCALE               .3f
#define PL_PFRS_DEFAULT_RING_LINE_WIDTH                         1.0f
#define PL_PFRS_DEFAULT_NODE_COUNT_PER_ROW                      3
#define PL_PFRS_DEFAULT_MINIMUM_NODE_COUNT                      4
#define PL_PFRS_DEFAULT_NODE_TABLE                              @[@"q", @"d", @"j", @"p", @"$", @"0", @"Xz", @"bM", @"^G"]

#endif
