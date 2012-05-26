//
//  GameScene.h
//  Evolution
//
//  Created by lev on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "EnergyBar.h"

@class HelloWorldLayer;

@interface GameScene : CCScene <CCTargetedTouchDelegate, EnergyBarDelegate>
 +(GameScene *) scene;
@end
