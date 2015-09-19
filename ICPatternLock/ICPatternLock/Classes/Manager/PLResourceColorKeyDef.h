//
//  PLResourceColorKeyDef.h
//  ICPatternLock
//
//  Created by _ivanC on 8/17/15.
//  Copyright (c) 2015 _ivanC. All rights reserved.
//

#ifndef ICPatternLock_PLResourceColorKeyDef_h
#define ICPatternLock_PLResourceColorKeyDef_h

//////////////////////////// Color ///////////////////////////
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//////////////////////////// Key ///////////////////////////
#define PL_RES_KEY_COLOR_BACKGROUND             @"PL_RES_KEY_COLOR_BACKGROUND"

#define PL_RES_KEY_COLOR_NAVI_TEXT              @"PL_RES_KEY_COLOR_NAVI_TEXT"
#define PL_RES_KEY_COLOR_HINT_TEXT              @"PL_RES_KEY_COLOR_HINT_TEXT"
#define PL_RES_KEY_COLOR_WARN_TEXT              @"PL_RES_KEY_COLOR_WARN_TEXT"

#define PL_RES_KEY_COLOR_CIRCLE_LINE_NORMAL     @"PL_RES_KEY_COLOR_CIRCLE_LINE_NORMAL"
#define PL_RES_KEY_COLOR_CIRCLE_LINE_SELECTED   @"PL_RES_KEY_COLOR_CIRCLE_LINE_SELECTED"

#define PL_RES_KEY_COLOR_CIRCLE_NORMAL          @"PL_RES_KEY_COLOR_CIRCLE_NORMAL"
#define PL_RES_KEY_COLOR_CIRCLE_SELECTED        @"PL_RES_KEY_COLOR_CIRCLE_SELECTED"

#define PL_RES_KEY_COLOR_ACTION_TEXT            @"PL_RES_KEY_COLOR_ACTION_TEXT"

//////////////////////////// Default Value ///////////////////////////

/*
 *  Background Color
 */
#define PL_RES_DEFAULT_COLOR_BACKGROUND rgba(33,82,89,1)

/*
 *  Navigation bar title color
 */
#define PL_RES_DEFAULT_COLOR_NAVI_TEXT rgba(241,241,241,1)

/*
 *  Hint message color
 */
#define PL_RES_DEFAULT_COLOR_HINT_TEXT PL_RES_DEFAULT_COLOR_NAVI_TEXT

/*
 *  Warning hint message color
 */
#define PL_RES_DEFAULT_COLOR_WARN_TEXT rgba(254,82,92,1)

/*
 *  Ring: Normal
 */
#define PL_RES_DEFAULT_COLOR_CIRCLE_LINE_NORMAL PL_RES_DEFAULT_COLOR_NAVI_TEXT

/*
 *  Ring: Selected
 */
#define PL_RES_DEFAULT_COLOR_CIRCLE_LINE_SELECTED rgba(34,178,246,1)

/*
 *  Filled circle: Normal
 */
#define PL_RES_DEFALUT_COLOR_CIRCLE_NORMAL PL_RES_DEFAULT_COLOR_NAVI_TEXT

/*
 *  Filled circle: Selected
 */
#define PL_RES_DEFALUT_COLOR_CIRCLE_SELECTED PL_RES_DEFAULT_COLOR_CIRCLE_LINE_SELECTED

/*
 *  Bottom action text color
 */
#define PL_RES_DEFAULT_COLOR_ACTION_TEXT PL_RES_DEFAULT_COLOR_NAVI_TEXT

#endif
