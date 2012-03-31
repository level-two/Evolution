//
//  HelloWorldLayer.m
//  Evolution
//
//  Created by lev on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "HelloWorldLayer.h"

@interface HelloWorldLayer ()
 @property (nonatomic, retain) CCSprite *bacilla;
 @property (nonatomic, retain) CCAction *moveAction;
 -(void)loadAnimations;
@end

@implementation HelloWorldLayer

@synthesize bacilla;
@synthesize moveAction;

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
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"_ZZu.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"_ZZu.png"];
    [self addChild:spriteSheet];
    
    NSMutableArray *bacillaMove = [NSMutableArray array];
    for (int i = 0; i < 7; i++)
    {
        [bacillaMove addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Phase%d_.png",i]]];
    }
    
    CCAnimation *movingBacilla = [CCAnimation animationWithFrames:bacillaMove delay:0.1f];
    
    self.bacilla = [CCSprite spriteWithSpriteFrameName:@"Phase0_.png"];
    bacilla.position = ccp(winSize.width/2, winSize.height/2);
    self.moveAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:movingBacilla restoreOriginalFrame:NO]];
    [bacilla runAction:moveAction];
    [spriteSheet addChild:bacilla];
}

////////////////////////////////
#pragma mark - Touches methods

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGFloat dx = location.x - bacilla.position.x;
    CGFloat dy = location.y - bacilla.position.y;
    
    CGFloat angle = atan2f(-dy, dx);
    
    [bacilla runAction:[CCSequence actions:[CCRotateTo actionWithDuration:0.1 angle:180*angle/M_PI],[CCMoveTo actionWithDuration:1 position:location], nil]];
}

////////////////////////////////

- (void) dealloc
{
	self.bacilla = nil;
    self.moveAction = nil;
    
	[super dealloc];
}
@end
