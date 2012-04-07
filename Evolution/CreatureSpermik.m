//
//  CreatureSpermik.m
//  Evolution
//
//  Created by lev on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreatureSpermik.h"

@implementation CreatureSpermik

+(CreatureSpermik*)create
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"_ZZu.plist"];
    CCSpriteBatchNode *spriteSheet = [CreatureSpermik batchNodeWithFile:@"_ZZu.png"];
    
    NSMutableArray *bacillaMove = [NSMutableArray array];
    for (int i = 0; i < 7; i++)
    {
        [bacillaMove addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Phase%d_.png",i]]];
    }

    CCAnimation *movingBacilla = [CCAnimation animationWithFrames:bacillaMove delay:0.1f];
    CreatureSpermik *spermik = [CCSprite spriteWithSpriteFrameName:@"Phase0_.png"];
    [spriteSheet addChild:spermik];

    return spriteSheet;
//    bacilla.position = ccp(winSize.width/2, winSize.height/2);
//    self.moveAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:movingBacilla restoreOriginalFrame:NO]];
//    [bacilla runAction:moveAction];
}


// init

- (id)init
{
    
}


// touch event delegate


// interaction with other creatures


// 


@end
