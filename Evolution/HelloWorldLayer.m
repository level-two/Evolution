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
 @property (nonatomic, retain) CCSprite *background;

// @property (nonatomic, retain) CCAction *moveAction;

 @property (nonatomic, retain) NSMutableArray *bugafishes;
 @property (nonatomic, retain) NSMutableArray *stars;
 @property (nonatomic, retain) NSMutableArray *redPills;
 @property (nonatomic, retain) NSMutableArray *greenPills;

 @property (nonatomic, assign) NSInteger maxFishes;
 @property (nonatomic, assign) NSInteger maxStars;
 @property (nonatomic, assign) NSInteger maxPills;

 @property (nonatomic, assign) CGSize winSize, worldSize;
 -(void)loadAnimations;
- (void)setup;
@end

@implementation HelloWorldLayer

@synthesize bacilla;
@synthesize background;
//@synthesize moveAction;
@synthesize bugafishes, stars;
@synthesize redPills, greenPills;

@synthesize maxFishes, maxStars, maxPills;
@synthesize winSize, worldSize;
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
    
    [[AnimationLoader sharedInstance] loadAnimationsFromDir:@"Sprites/" recursive:YES];
    
    [self initBackground];    
    [self initBacilla];
    self.winSize = [[CCDirector sharedDirector] winSize];
    self.worldSize = background.textureRect.size; // will be changed in future
    [self addBackground];
    [self addBacilla];
    
    [self schedule:@selector(update:) interval:1.0];
    maxFishes = 5; // this constants should be recalculated later
    maxStars = 3;  // depending on LEVEL or SCORE
    maxPills = 6;
}

//--------------------------------------------------------------

- (void)initBacilla
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"_ZZu"];
    if (bn)
        [self addChild:bn z:1];
    self.bacilla = [[AnimationLoader sharedInstance] spriteWithName:@"Bacilla"];
    CCAnimation *bacillaAnim = [[AnimationLoader sharedInstance] animationWithName:@"Bacilla"];
    CCAction *moveAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:bacillaAnim restoreOriginalFrame:NO]];
    [bacilla runAction:moveAction];
}

- (void)initBackground
{
    self.background = [CCSprite spriteWithFile:@"Sprites/PollenTetrads.jpg"];}

- (void)initBugafish
{
    
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

- (void)addBackground
{
    [self addChild:background z:0];
    background.position = ccp( winSize.width/2, winSize.height/2);
}

- (void)addBacilla
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"_ZZu"];
    [bn addChild:bacilla];
    bacilla.position = ccp(winSize.width/2, winSize.height/2);
}

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
    
    CGFloat dx = location.x - winSize.width/2;
    CGFloat dy = location.y - winSize.height/2;
    
    CGFloat angle = atan2f(-dy, dx);
    
//    [bacilla runAction:[CCSequence actions:[CCRotateTo actionWithDuration:0.1 angle:180*angle/M_PI], nil]];
    [bacilla runAction:[CCRotateTo actionWithDuration:0.1 angle:180*angle/M_PI]];
    [background runAction:[CCSequence actions:[CCActionInterval actionWithDuration:0.1], 
                           [CCMoveBy actionWithDuration:1 position:ccp(-dx,-dy)], 
                           nil]];
    
}


//--------------------------------------------------------------

- (void)update:(ccTime)dt
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
    self.background = nil;
    
    self.bugafishes = nil;
    self.stars = nil;
    self.redPills = nil;
    self.greenPills = nil;
    
	[super dealloc];
}
@end
