//
//  HelloWorldLayer.m
//  Evolution
//
//  Created by lev on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "AnimationLoader.h"

#define moveActionTag 100500

@interface HelloWorldLayer ()
 @property (nonatomic, retain) CCSprite *bacilla;
 @property (nonatomic, retain) CCSprite *background;

 @property (nonatomic, retain) CCAnimation *bacillaAnimation;
 @property (nonatomic, retain) CCAnimate *bacillaMoveAction;

 @property (nonatomic, retain) CCAnimation *bugafishAnimation;
 @property (nonatomic, retain) CCAnimate *bugafishMoveAction;

 @property (nonatomic, retain) NSMutableArray *bugafishes;
 @property (nonatomic, retain) NSMutableArray *stars;
 @property (nonatomic, retain) NSMutableArray *redPills;
 @property (nonatomic, retain) NSMutableArray *greenPills;

 @property (nonatomic, assign) NSInteger maxFishes;
 @property (nonatomic, assign) NSInteger maxStars;
 @property (nonatomic, assign) NSInteger maxPills;

 @property (nonatomic, assign) BOOL bacDoublespeeded;

 @property (nonatomic, assign) CGSize winSize, worldSize;
 @property (nonatomic, assign) CGRect worldBounds;
 @property (nonatomic, retain) NSDate *prevTapTime;

 -(void)loadAnimations;
- (void)setup;
@end

@implementation HelloWorldLayer

 @synthesize bacilla;
 @synthesize background;

 @synthesize bacillaMoveAction;
 @synthesize bacillaAnimation;

 @synthesize bugafishAnimation;
 @synthesize bugafishMoveAction;

 @synthesize bugafishes, stars;
 @synthesize redPills, greenPills;

 @synthesize bacDoublespeeded;

 @synthesize maxFishes, maxStars, maxPills;
 @synthesize winSize, worldSize;
 @synthesize worldBounds;

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
    [self initBugafish];
    
    self.winSize = [[CCDirector sharedDirector] winSize];
    self.worldSize = background.textureRect.size; // will be changed in future
    self.worldBounds = CGRectMake(0, 0, worldSize.width, worldSize.height);
    
    [self addBackground];
    [self addBacilla];
    [self addBugafish];
    
    self.prevTapTime = [NSDate date];
    
    maxFishes = 5; // this constants should be recalculated later
    maxStars = 3;  // depending on LEVEL or SCORE
    maxPills = 6;
    
    [self scheduleUpdate];
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
    self.bugafishes = [NSMutableArray array];
    
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bugafish"];
    if (bn)
        [self addChild:bn z:1];
    self.bugafishAnimation = [[AnimationLoader sharedInstance] animationWithName:@"Bugafish_move"];
    self.bugafishMoveAction = [CCAnimate actionWithAnimation:bugafishAnimation restoreOriginalFrame:NO];
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
    CGFloat w = worldSize.width;
    CGFloat h = worldSize.height;
    background.position = ccp(w/2, h/2);
    
	[self runAction:[CCFollow actionWithTarget:bacilla worldBoundary:CGRectMake(0,0,w,h)]];
}

- (void)addBacilla
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bacilla"];
    [bn addChild:bacilla];
    
    CGFloat w = worldSize.width/2;
    CGFloat h = worldSize.height/2;
    bacilla.position = ccp(w,h);
}

- (void)addBugafish
{
    CCSprite *bugafish = [[AnimationLoader sharedInstance] spriteWithName:@"Bugafish_move"];
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bugafish"];
    [bn addChild:bugafish];
    
    CGFloat w = worldSize.width/2;
    CGFloat h = worldSize.height/2;
    bugafish.position = ccp(w,h);
    
    [bugafish runAction:[CCRepeatForever actionWithAction:bugafishMoveAction]];
    
    [bugafishes addObject:bugafish];
    [self bugafishUpdate:bugafish];
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

- (void)bugafishUpdate:(CCSprite*)bugafish
{
    CGPoint bacPos = bacilla.position;
    CGPoint bugaPos = bugafish.position;
    
    CGFloat dx;
    CGFloat dy;
    
    CGFloat minDist = 200; // distance when buga see the hero and move towards him
    if ([self isHeroCanBeSeenBy:bugafish] && (ccpDistance(bacPos, bugaPos) < minDist))
    {
        dx = bacilla.position.x - bugafish.position.x - 50 + rand()%100;
        dy = bacilla.position.y - bugafish.position.y - 30 + rand()%60;
    }
    else
    {
        dx = -200 + random()%400;
        dy = -30  + random()%60;
    }
    
    CGFloat moveTime  = 1.0;
    CGFloat delayTime = 0.8 + random()%2;
    
    CCActionInterval *move = [CCMoveBy        actionWithDuration:moveTime position:ccp(dx,dy)];
    CCAction *easedMove    = [CCEaseSineInOut actionWithAction:move];
    CCAction *delay        = [CCDelayTime     actionWithDuration:delayTime];
    
    CGFloat sgnX = dx<0 ? -1 : 1;
    bugafish.scaleX = sgnX;
    
    NSMutableArray *actions = [NSMutableArray arrayWithObjects:easedMove, delay, nil];
    
    // check whether buga needs to be updated after move or deleted (when it run out of the world bounds)
    CGPoint endPos = ccp(bugafish.position.x + dx, bugafish.position.y + dy);
    if(CGRectContainsPoint(worldBounds, endPos))
    {
        CCAction *updateCall = [CCCallFuncN actionWithTarget:self selector:@selector(bugafishUpdate:)];
        [actions addObject:updateCall];
    }
    else
    {
        CCAction *removeCall = [CCCallFuncN actionWithTarget:self selector:@selector(bugafishRemove:)];
        [actions addObject:removeCall];
    }
    
    [bugafish runAction:[CCSequence actionsWithArray:actions]];
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

- (void)bugafishRemove:(CCSprite*)buga
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bugafish"];
    [bn removeChild:buga cleanup:YES];
}

- (void)dashBuga:(CCSprite*)buga
{
    [buga stopAllActions];
    
    CGFloat angle = bacilla.rotation;
    if (bacilla.scaleX < 0) angle = 180 - angle;
    angle *= M_PI/180; // radians
    
    CGFloat moveDist = 200;
    CGFloat dx = moveDist*cos(angle);
    CGFloat dy = moveDist*sin(angle);
    
    id rotation         = [CCRotateBy actionWithDuration:0.5 angle:360];
    id repeatedRotation = [CCRepeat actionWithAction:rotation times:4];
    id easedRepRotation = [CCEaseOut actionWithAction:repeatedRotation];
    id move             = [CCMoveBy actionWithDuration:2 position:ccp(dx,dy)];
    id spawnedActions   = [CCSpawn actions:easedRepRotation, move, nil];
    
    id callUpdate       = [CCCallFuncN actionWithTarget:self selector:@selector(bugafishUpdate:)];
    id allActions       = [CCSequence actions:spawnedActions, callUpdate, nil];
    
    [buga runAction:allActions];
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
    
    CGFloat sgnX = dx<0 ? -1 : 1;
    CGFloat angle = atan2f( -dy*sgnX, fabs(dx)) *180/M_PI;
    
    // TODO: start horizontal rotation animation here
    if (sgnX == bacilla.scaleX) 
        [bacilla runAction:[CCRotateTo actionWithDuration:0.1 angle:angle]];
    else
        bacilla.rotation = angle; // if direction changed - do not rotate
    
    bacilla.scaleX = sgnX; // change direction if needed
    
    
    CGFloat moveDuration;
    NSTimeInterval ti = -[prevTapTime timeIntervalSinceNow];
    if (ti > 0.2)
    {
        moveDuration = 1.5;
        bacillaAnimation.delay = 0.1;
        bacDoublespeeded = NO;
    }
    else
    {
        // if tap period is small - move hero with double speed
        moveDuration = 0.75;
        bacillaAnimation.delay = 0.08;
        bacDoublespeeded = YES;
    }
    self.prevTapTime = [NSDate date];
    
    
    [bacilla stopActionByTag:moveActionTag];
    CCAction *moveAction = [CCSequence actions: [CCEaseSineOut actionWithAction:
                                                 [CCMoveBy actionWithDuration:moveDuration position:ccp(dx,dy)]],
                            [CCCallBlock actionWithBlock:^(void)
                             { 
                                 bacillaAnimation.delay = 0.2;
                                 bacDoublespeeded = NO;
                             }],
                            nil];
    moveAction.tag = moveActionTag;
    [bacilla runAction:moveAction];
}

//--------------------------------------------------------------

- (void)update:(ccTime)dt
{
    CGRect bacRect = CGRectMake(bacilla.position.x - bacilla.contentSize.width/2,
                                bacilla.position.y - bacilla.contentSize.height/2,
                                bacilla.contentSize.width,
                                bacilla.contentSize.height);
    for (CCSprite* buga in bugafishes)
    {
        if ([self collisionDetection:buga withRect:bacRect])
        {
            if ([self isHeroCanBeSeenBy:buga])
            {
//                [self gamover];
            }
            else if (bacDoublespeeded)
            {
                [self dashBuga:buga];
            }
            
            [bacilla stopActionByTag:moveActionTag];
        }
    }
}

//--------------------------------------------------------------

- (BOOL)isHeroCanBeSeenBy:(CCSprite*)evilCreature
{
    // check direction towards hero and rotation of the creature
    return (bacilla.position.x - evilCreature.position.x)*evilCreature.scaleX > 0;
}

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

- (BOOL)collisionDetection:(CCSprite*)s1 withRect:(CGRect)rect2
{
//    static CCSprite *cachedsprite = nil;
//    static CGRect cachedrect = {0,0,0,0};
//    if (cachedsprite!=s1)
//    {
//        cachedsprite = s1;
      CGRect rect1 = CGRectMake(s1.position.x - s1.contentSize.width/2,
                                s1.position.y - s1.contentSize.height/2,
                                s1.contentSize.width,
                                s1.contentSize.height);
//    }
//    CGRect s2rect = CGRectMake(s2.position.x - s2.contentSize.width/2,
//                               s2.position.y - s2.contentSize.height/2,
//                               s2.contentSize.width,
//                               s2.contentSize.height);
    return CGRectIntersectsRect(rect1, rect2);
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	self.bacilla = nil;
    self.bacillaAnimation =nil;
    self.bacillaMoveAction = nil;
    self.background = nil;
    
    self.bugafishAnimation = nil;
    self.bugafishMoveAction = nil;
    
    self.bugafishes = nil;
    self.stars = nil;
    self.redPills = nil;
    self.greenPills = nil;
    
    self.prevTapTime = nil;
    
	[super dealloc];
}
@end
