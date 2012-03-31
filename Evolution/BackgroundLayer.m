//
//  HelloWorldLayer.m
//  Evolution
//
//  Created by lev on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "BackgroundLayer.h"

@interface BackgroundLayer ()
 -(void)loadAnimations;
@end

@implementation BackgroundLayer

-(id) init
{
	if((self = [super init])) 
    {
        [self loadAnimations];
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void)loadAnimations
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *bg = [CCSprite spriteWithFile:@"PollenTetrads.jpg"];
    [self addChild:bg];
    bg.position =  ccp(winSize.width/2, winSize.height/2);
}

- (void) dealloc
{
	[super dealloc];
}
@end
