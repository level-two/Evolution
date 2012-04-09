//
//  HelloWorldLayer.m
//  Evolution
//
//  Created by lev on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "AnimationLoader.h"

@interface HelloWorldLayer ()
 @property (nonatomic, retain) CCSprite *bacilla;
// @property (nonatomic, retain) CCAction *moveAction;

 @property (nonatomic, retain) NSMutableArray *bugafishes;
 @property (nonatomic, retain) NSMutableArray *stars;
 @property (nonatomic, retain) NSMutableArray *redPills;
 @property (nonatomic, retain) NSMutableArray *greenPills;

 @property (nonatomic, assign) NSInteger maxFishes;
 @property (nonatomic, assign) NSInteger maxStars;
 @property (nonatomic, assign) NSInteger maxPills;

 @property (nonatomic, assign) CGSize winSize;
 -(void)loadAnimations;
- (void)setup;
@end

@implementation HelloWorldLayer

@synthesize bacilla;
//@synthesize moveAction;
@synthesize bugafishes, stars;
@synthesize redPills, greenPills;

@synthesize maxFishes, maxStars, maxPills;
@synthesize winSize;
//--------------------------------------------------------------

-(id) init
{
	if((self = [super init])) 
    {
        [self setup];
	}
	return self;
}

- (void)setup
{
    self.isTouchEnabled = YES;
    self.winSize = [[CCDirector sharedDirector] winSize];
    [[AnimationLoader sharedInstance] loadAnimationsFromDir:@"Sprites/" recursive:YES];
    
    [self initBacilla];
    
    [self schedule:@selector(update:) interval:1.0];
    maxFishes = 5; // this constants should be recalculated later
    maxStars = 3;  // depending on LEVEL or SCORE
    maxPills = 6;
}

//--------------------------------------------------------------

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


//--------------------------------------------------------------

- (void)update:(ccTime)dt
{
    
}

//--------------------------------------------------------------


- (void)initBacilla
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"_ZZu"];
    if (bn) 
        [self addChild:bn];
    self.bacilla = [[AnimationLoader sharedInstance] spriteWithName:@"Bacilla"];
    CCAnimation *bacillaAnim = [[AnimationLoader sharedInstance] animationWithName:@"Bacilla"];
    CCAction *moveAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:bacillaAnim restoreOriginalFrame:NO]];
    [bacilla runAction:moveAction];
    [bn addChild:bacilla];
    
    bacilla.position = ccp(winSize.width/2, winSize.height/2);
}

- (void)initBugafish
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Bugafish.plist"];
//    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"Bugafish.png"];
//    [self addChild:spriteSheet];
//    
//    NSMutableArray *bugaFrames = [NSMutableArray array];
//    for (int i = 0; i < 7; i++)
//    {
//        [bugaFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Buga_%d.png",i]]];
//    }
//    
//    CCAnimation *bugaAnim = [CCAnimation animationWithFrames:bugaFrames delay:0.1f];
    
    
    
//    self.bacilla = [CCSprite spriteWithSpriteFrameName:@"Phase0_.png"];
//    bacilla.position = ccp(winSize.width/2, winSize.height/2);
//    self.moveAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:bugaAnim restoreOriginalFrame:NO]];
//    [bacilla runAction:moveAction];
//    [spriteSheet addChild:bacilla];
    
    
    
    
}

- (void)initStar
{
    
}

- (void)initRedPill
{
    
}

- (void)initGreenPill
{
    
}

- (void)initBuka
{
    
}

//--------------------------------------------------------------


- (void)addBugafish
{
    
}

- (void)addStar
{
    
}

- (void)addRedPill
{
    
}

- (void)addGreenPill
{
    
}

- (void)addBuka
{
    
}

//--------------------------------------------------------------

- (void)bugafishCollision
{
    
}

- (void)starCollision
{
    
}

- (void)redPillColllision
{
    
}

- (void)greenPillCollision
{
    
}

- (void)bukaCollision
{
    
}

//--------------------------------------------------------------

- (void)bugafishUpdate
{
    
}

- (void)starUpdate
{
    
}

- (void)redPillUpdate
{
    
}

- (void)greenPillUpdate
{
    
}

- (void)bukaUpdate
{
    
}

//--------------------------------------------------------------

- (BOOL)collisionDetection:(CCSprite*)s1 with:(CCSprite*)s2
{
    static CCSprite *cachedsprite = nil;
    static CGRect cachedrect = {0,0,0,0};
    if (cachedsprite!=s1)
    {
        cachedsprite = s1;
        cachedrect = CGRectMake(s1.position.x - s1.contentSize.width/2,
                                s1.position.y - s1.contentSize.height/2,
                                s1.contentSize.width,
                                s1.contentSize.height);
    }
    CGRect s2rect = CGRectMake(s2.position.x - s2.contentSize.width/2,
                               s2.position.y - s2.contentSize.height/2,
                               s2.contentSize.width,
                               s2.contentSize.height);
    return CGRectIntersectsRect(cachedrect, s2rect);
}

- (void) dealloc
{
	self.bacilla = nil;
//    self.moveAction = nil;
    self.bugafishes = nil;
    self.stars = nil;
    self.redPills = nil;
    self.greenPills = nil;
    
	[super dealloc];
}
@end
