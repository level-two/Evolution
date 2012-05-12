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

 @property (nonatomic, retain) CCAnimate *bacillaMoveAction;
 @property (nonatomic, retain) CCAnimation *bacillaAnimation;

 @property (nonatomic, retain) NSMutableArray *bugafishes;
 @property (nonatomic, retain) NSMutableArray *stars;
 @property (nonatomic, retain) NSMutableArray *redPills;
 @property (nonatomic, retain) NSMutableArray *greenPills;

 @property (nonatomic, assign) NSInteger maxFishes;
 @property (nonatomic, assign) NSInteger maxStars;
 @property (nonatomic, assign) NSInteger maxPills;

 @property (nonatomic, assign) CGSize winSize, worldSize;
 @property (nonatomic, retain) NSDate *prevTapTime;

 -(void)loadAnimations;
- (void)setup;
@end

@implementation HelloWorldLayer

@synthesize bacilla;
@synthesize background;

@synthesize bacillaMoveAction;
@synthesize bacillaAnimation;

@synthesize bugafishes, stars;
@synthesize redPills, greenPills;

@synthesize maxFishes, maxStars, maxPills;
@synthesize winSize, worldSize;

@synthesize prevTapTime;
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
    
    self.prevTapTime = [NSDate date];
    
    [self schedule:@selector(update:) interval:1.0];
    maxFishes = 5; // this constants should be recalculated later
    maxStars = 3;  // depending on LEVEL or SCORE
    maxPills = 6;
}

//--------------------------------------------------------------

- (void)initBacilla
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bacilla"];
    if (bn)
        [self addChild:bn z:1];
    self.bacilla = [[AnimationLoader sharedInstance] spriteWithName:@"anim"];
    self.bacillaAnimation = [[AnimationLoader sharedInstance] animationWithName:@"anim"];
    self.bacillaMoveAction = [CCAnimate actionWithAnimation:bacillaAnimation restoreOriginalFrame:NO];
    [bacilla runAction:[CCRepeatForever actionWithAction:bacillaMoveAction]];
}

- (void)initBackground
{
    self.background = [CCSprite spriteWithFile:@"Sprites/ocean.png"];
}

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
    CGFloat w = background.textureRect.size.width;
    CGFloat h = background.textureRect.size.height;
    background.position = ccp(w/2, h/2);
    
	[self runAction:[CCFollow actionWithTarget:bacilla worldBoundary:CGRectMake(0,0,w,h)]];
}

- (void)addBacilla
{
    CGFloat w = background.textureRect.size.width/2;
    CGFloat h = background.textureRect.size.height/2;
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bacilla"];
    [bn addChild:bacilla];
    bacilla.position = ccp(w,h);
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
    
    CGFloat bScrX = bacilla.position.x + self.position.x;
    CGFloat bScrY = bacilla.position.y + self.position.y;
    
    CGFloat dx = location.x - bScrX;
    CGFloat dy = location.y - bScrY;
    
    CGFloat angle = atan2f(-dy, dx);
    
    NSTimeInterval ti = -[prevTapTime timeIntervalSinceNow];
    CGFloat moveDuration = ti > 0.2 ? 1.5 : 0.75; // if tap period is small - move hero with double speed
    bacillaAnimation.delay = ti > 0.2 ? 0.1 : 0.08;
    self.prevTapTime = [NSDate date];
    
    [bacilla stopActionByTag:100500];
    [bacilla runAction:[CCRotateTo actionWithDuration:0.1 angle:180*angle/M_PI]];
    
    CCAction *moveAction = [CCSequence actions: [CCEaseSineOut actionWithAction:
                                                 [CCMoveBy actionWithDuration:moveDuration position:ccp(dx,dy)]],
                            [CCCallBlock actionWithBlock:^(void){ bacillaAnimation.delay = 0.2; }],
                            nil];
    moveAction.tag = 100500;
    [bacilla runAction:moveAction];
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
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	self.bacilla = nil;
    self.bacillaAnimation =nil;
    self.bacillaMoveAction = nil;
    self.background = nil;
    
    self.bugafishes = nil;
    self.stars = nil;
    self.redPills = nil;
    self.greenPills = nil;
    
    self.prevTapTime = nil;
    
	[super dealloc];
}
@end
