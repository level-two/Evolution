//
//  GameScene.m
//  Evolution
//
//  Created by lev on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "HelloWorldLayer.h"
#import "BackgroundLayer.h"

@implementation GameScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    
//    CCLayerColor *cclc = [CCLayerColor node];
//    [cclc setColor:ccc3(255, 255, 255)];
//    [cclc setOpacity:100]; 
//    CCLayerColor *cclc = [CCLayerColor layerWithColor:ccc4(10, 10, 50, 255)];
//    [scene addChild:cclc];
    
    BackgroundLayer *bg = [BackgroundLayer node];
    [scene addChild:bg];
    
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

@end
