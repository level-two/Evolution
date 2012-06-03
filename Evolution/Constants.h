//
//  Constants.h
//  Evolution
//
//  Created by lev on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Evolution_Constants_h
#define Evolution_Constants_h

// tags
#define bacTag 1
#define bugaTouchableTag 2
#define bugaUntouchableTag 3
#define greenPillTag 4
#define redPillTag 5

// motion constants
#define DoubleSpeedDenyTime 1.5
#define MinTouchRadius 100 // minimum distance of touch to bacilla
#define BacVelocity 150 // px/s
#define StrongHitMinDistance 50
#define BacDapDist 30
#define BacDapTime 0.5

#define BugaWeakHitShortDist 50
#define BugaWeakHitLongDist 100
#define BugaStrongHitShortDist 150
#define BugaStrongHitLongDist 200

#define GreenPillFallingSpeed 40 // px/s

#define BugaRotationSpeed 360/1.0 // degrees/sec

// Actions
#define bacMoveActionTag 100500
#define bugaDashedActionTag 100501
#define bacDappingActionTag 100502
#define bugaMoveActionTag 100503

#endif
