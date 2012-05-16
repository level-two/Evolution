//
//  HelloWorldLayer.m
//  Evolution
//
//  Created by lev on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "AnimationLoader.h"

#define DoubleSpeedDenyTime 1.5
#define MinTouchRadius 100 // minimum distance of touch to bacilla
#define BacVelocity 150 // px/s
#define StrongHitMinDistance 50

#define BugaWeakHitShortDist 50
#define BugaWeakHitLongDist 100
#define BugaStrongHitShortDist 150
#define BugaStrongHitLongDist 200


#define bacMoveActionTag 100500
#define bugaDashedActionTag 100501

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
 @property (nonatomic, assign) BOOL denyDoubleSpeed;
 @property (nonatomic, assign) BOOL canMakeStrongHit; // indicates when hero accelerated enoguh to make strong hit

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
 @synthesize denyDoubleSpeed;
 @synthesize canMakeStrongHit;

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
    
    self.prevTapTime = [NSDate dateWithTimeIntervalSince1970:0];
    
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
    
//    bacilla.rotation = 45;
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
//    [self dashBuga:bugafish]; //debug
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
    
    CGFloat dx;
    CGFloat dy;
    
    id repeatedRotation = nil;
    
    if (!bacDoublespeeded)
    {
        if (!canMakeStrongHit)
        {
            dx = BugaWeakHitShortDist*cos(angle);
            dy = BugaWeakHitShortDist*sin(angle);
        }
        else
        {
            dx = BugaWeakHitLongDist*cos(angle);
            dy = BugaWeakHitLongDist*sin(angle);
        }
    }
    else
    {
        if (!canMakeStrongHit)
        {
            dx = BugaStrongHitShortDist*cos(angle);
            dy = BugaStrongHitShortDist*sin(angle);
        }
        else
        {
            dx = BugaStrongHitLongDist*cos(angle);
            dy = BugaStrongHitLongDist*sin(angle);
            id rotation         = [CCRotateBy actionWithDuration:0.5 angle:180];
            repeatedRotation = [CCRepeat actionWithAction:rotation times:4];
        }
    }
    id move             = [CCMoveBy actionWithDuration:2 position:ccp(dx,dy)];
    id spawnedActions   = [CCSpawn actions:move, repeatedRotation, nil];
    
    id callUpdate       = [CCCallFuncN actionWithTarget:self selector:@selector(bugafishUpdate:)];
//    id callUpdate = [CCCallBlockN actionWithBlock:^(CCNode *n)
//                                         { n.position = ccp(worldSize.width/2, worldSize.height/2);}]; // debug
    
    
    id allActions       = [CCEaseSineOut actionWithAction:[CCSequence actions:spawnedActions, callUpdate, nil]];
    
    ((CCAction*)allActions).tag = bugaDashedActionTag;
    [buga runAction:allActions];
//    [buga runAction:[CCRepeatForever actionWithAction:allActions]]; // debug
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
    
    
    CGFloat dist = ccpDistance(location, ccp(bScrX, bScrY));
    CGFloat moveDuration = dist / BacVelocity;
    NSTimeInterval ti = -[prevTapTime timeIntervalSinceNow];
    if (ti > 0.2 || denyDoubleSpeed)
    {
        bacillaAnimation.delay = 0.1;
        bacDoublespeeded = NO;
    }
    else
    {
        // if tap period is small - move hero with double speed
        moveDuration /= 2;
        bacillaAnimation.delay = 0.08;
        bacDoublespeeded = YES;
        denyDoubleSpeed = YES;
        [self performSelector:@selector(allowDoubleSpeed) withObject:nil afterDelay:DoubleSpeedDenyTime];
    }
    
    self.prevTapTime = [NSDate date];
    

    id stopped = [CCCallBlock actionWithBlock:^(void)
                  { 
                      bacillaAnimation.delay = 0.2;
                      bacDoublespeeded = NO;
                      canMakeStrongHit = NO; //reset when stopped
                  }];
    
    CCSequence *sequence;
    if (dist < StrongHitMinDistance)
    {
        id moveBy = [CCMoveBy actionWithDuration:moveDuration position:ccp(dx,dy)];
        sequence = [CCSequence actions:moveBy, stopped, nil];
    }
    else
    {
        CGFloat k = StrongHitMinDistance/dist;
        CGFloat dx1 = dx*k;
        CGFloat dy1 = dy*k;
        CGFloat dt1 = moveDuration*k;
        CGFloat dx2 = dx-dx1;
        CGFloat dy2 = dy-dy1;
        CGFloat dt2 = moveDuration-dt1;
        id move1 = [CCMoveBy actionWithDuration:dt1 position:ccp(dx1,dy1)];
        id move1End = [CCCallBlock actionWithBlock:^(void){ canMakeStrongHit = YES;}];
        id move2 = [CCMoveBy actionWithDuration:dt2 position:ccp(dx2,dy2)];
        sequence = [CCSequence actions:move1, move1End, move2, stopped, nil];        
    }
    
    CCAction *easedMove = [CCEaseSineOut actionWithAction: sequence];
    easedMove.tag = bacMoveActionTag;
    [bacilla stopActionByTag:bacMoveActionTag];
    [bacilla runAction:easedMove];
}

- (void)allowDoubleSpeed
{
    denyDoubleSpeed = NO;
    NSLog(@"Yo!! DOubleSPeed allowed!");
}

//--------------------------------------------------------------

- (void)update:(ccTime)dt
{
    CGFloat w = bacilla.displayedFrame.rect.size.width;
    CGFloat h = bacilla.displayedFrame.rect.size.height;
    CGRect bacRect = CGRectMake(bacilla.position.x - w/2, bacilla.position.y - h/2, w, h);
    for (CCSprite* buga in bugafishes)
    {
        if ([buga getActionByTag:bugaDashedActionTag]) continue; // skip dashed bugafish
        if ([self collisionDetection:buga withRect:bacRect])
        {
            if ([self isHeroCanBeSeenBy:buga])
            {
//                [self gamover];
            }
            else //if (bacDoublespeeded)
            {
                [self dashBuga:buga];
            }
            
            [bacilla stopActionByTag:bacMoveActionTag];
        }
    }
}

//--------------------------------------------------------------

- (BOOL)isHeroCanBeSeenBy:(CCSprite*)evilCreature
{
    // check direction towards hero and rotation of the creature
    return (bacilla.position.x - evilCreature.position.x)*evilCreature.scaleX > 0;
}

- (BOOL)collisionDetection:(CCSprite*)s1 withRect:(CGRect)rect2
{
    CGFloat w = s1.displayedFrame.rect.size.width;
    CGFloat h = s1.displayedFrame.rect.size.height;
    CGRect rect1 = CGRectMake(s1.position.x - w/2, s1.position.y - h/2, w, h);
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
