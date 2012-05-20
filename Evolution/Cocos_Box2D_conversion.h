//
//  Cocos_Box2D_conversion.h
//  Evolution
//
//  Created by lev on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Evolution_Cocos_Box2D_conversion_h
#define Evolution_Cocos_Box2D_conversion_h

 #define PTM_RATIO 40.0f
 #define SCREEN_TO_WORLD(n) ((n) / (CC_CONTENT_SCALE_FACTOR()*PTM_RATIO))
 #define WORLD_TO_SCREEN(n) ((n) * (CC_CONTENT_SCALE_FACTOR()*PTM_RATIO))
 #define B2_ANGLE_TO_COCOS_ROTATION(n) (-1 * CC_RADIANS_TO_DEGREES(n))
 #define COCOS_ROTATION_TO_B2_ANGLE(n) (CC_DEGREES_TO_RADIANS(-1 * n))

#endif
