//
//  GameScene.m
//  Evolution
//
//  Created by lev on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "HelloWorldLayer.h"
#import "StatusLayer.h"
#import "AnimationLoader.h"
#import "Box2D/Box2D.h"
#import "Cocos_Box2D_conversion.h"
#import "Constants.h"
#import "EnergyBar.h"

static b2PolygonShape *bugaPoly;
static b2PolygonShape *bacPoly;

@interface GameScene ()
 @property (nonatomic, retain) HelloWorldLayer *helloWorldLayer;
 @property (nonatomic, retain) StatusLayer *statusLayer;

 @property (nonatomic, retain) CCSprite *bacilla;
 @property (nonatomic, retain) CCSprite *background;

 @property (nonatomic, retain) CCAnimation *bacillaAnimation;
 @property (nonatomic, retain) CCAnimate *bacillaMoveAnimation;

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

 @property (nonatomic, retain) EnergyBar *energyBar;

 - (void)setup;
 - (void)initBacilla;
 - (void)initBackground;
 - (void)initBugafish;
 - (void)addBackground;
 - (void)addBacilla;
 - (void)addBugafish;

 - (void)bugafishUpdate:(CCSprite*)bugafish;

 - (BOOL)collisionDetection:(CCSprite*)s1 with:(CCSprite*)s2;
 - (BOOL)isHeroCanBeSeenBy:(CCSprite*)evilCreature;
@end


@implementation GameScene
 @synthesize helloWorldLayer;
 @synthesize statusLayer;

 @synthesize bacilla;
 @synthesize background;

 @synthesize bacillaMoveAnimation;
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

 @synthesize energyBar;

//--------------------------------------------------------------

+(GameScene *) scene
{
	GameScene *scene = [GameScene node];

	return scene;
}

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
    [[AnimationLoader sharedInstance] loadAnimationsFromDir:@"Sprites/" recursive:YES];
    
    [self initLayers];
    
    [self initBackground];    
    [self initBacilla];
    [self initBugafish];
    [self initEnergyBar];
    
    self.winSize = [[CCDirector sharedDirector] winSize];
    self.worldSize = background.textureRect.size; // will be changed in future
    self.worldBounds = CGRectMake(0, 0, worldSize.width, worldSize.height);
    
    [self addBackground];
    [self addBacilla];
    [self addBugafish];
    [self addEnergyBar];
    
    self.prevTapTime = [NSDate dateWithTimeIntervalSince1970:0];
    
    maxFishes = 5; // this constants should be recalculated later
    maxStars = 3;  // depending on LEVEL or SCORE
    maxPills = 6;
    
    [self registerWithTouchDispatcher];
    [self scheduleUpdate];
}

//--------------------------------------------------------------

- (void)initLayers
{
	self.helloWorldLayer = [HelloWorldLayer node];
	[self addChild:helloWorldLayer];
    
	self.statusLayer = [StatusLayer node];
	[self addChild:statusLayer];
}

- (void)initBacilla
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bacilla"];
    if (bn)
        [helloWorldLayer addChild:bn z:1];
    self.bacilla = [[AnimationLoader sharedInstance] spriteWithName:@"anim"];
    self.bacillaAnimation = [[AnimationLoader sharedInstance] animationWithName:@"anim"];
    self.bacillaMoveAnimation = [CCAnimate actionWithAnimation:bacillaAnimation restoreOriginalFrame:NO];
    [bacilla runAction:[CCRepeatForever actionWithAction:bacillaMoveAnimation]];
    bacilla.tag = bacTag;
    
    int num = 5;
    b2Vec2 verts[] = {
        b2Vec2(22.7f / PTM_RATIO, 3.2f / PTM_RATIO),
        b2Vec2(10.9f / PTM_RATIO, 8.6f / PTM_RATIO),
        b2Vec2(-1.9f / PTM_RATIO, 0.0f / PTM_RATIO),
        b2Vec2(10.5f / PTM_RATIO, -7.7f / PTM_RATIO),
        b2Vec2(22.0f / PTM_RATIO, -3.2f / PTM_RATIO)
    };
    
    bacPoly = new b2PolygonShape();
    bacPoly->Set(verts, num);
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
        [helloWorldLayer addChild:bn z:1];
    self.bugafishAnimation = [[AnimationLoader sharedInstance] animationWithName:@"Bugafish_move"];
    self.bugafishMoveAction = [CCAnimate actionWithAnimation:bugafishAnimation restoreOriginalFrame:NO];
    
    int nb = 7; // buga poly
    b2Vec2 bp[] = {
        b2Vec2(-24.5f / PTM_RATIO, -6.7f / PTM_RATIO),
        b2Vec2(0.0f / PTM_RATIO, -25.0f / PTM_RATIO),
        b2Vec2(22.2f / PTM_RATIO, -24.7f / PTM_RATIO),
        b2Vec2(30.5f / PTM_RATIO, -15.5f / PTM_RATIO),
        b2Vec2(31.0f / PTM_RATIO, 15.2f / PTM_RATIO),
        b2Vec2(-4.7f / PTM_RATIO, 19.7f / PTM_RATIO),
        b2Vec2(-23.7f / PTM_RATIO, 6.5f / PTM_RATIO)
    };
    
    bugaPoly = new b2PolygonShape();
    bugaPoly->Set(bp, nb);
}

- (void)initEnergyBar
{
    self.energyBar = [EnergyBar createWithDrainSpeed:0.3 regenerationSpeed:0.1];
    energyBar.delegate = self;
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
    [helloWorldLayer addChild:background z:0];
    CGFloat w = worldSize.width;
    CGFloat h = worldSize.height;
    background.position = ccp(w/2, h/2);
    
	[helloWorldLayer runAction:[CCFollow actionWithTarget:bacilla worldBoundary:CGRectMake(0,0,w,h)]];
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
    bugafish.tag = bugaTouchableTag;
    
    CGFloat w = worldSize.width/2;
    CGFloat h = worldSize.height/2;
    bugafish.position = ccp(w+100,h);
    
    [bugafish runAction:[CCRepeatForever actionWithAction:bugafishMoveAction]];
    
    [bugafishes addObject:bugafish];
    [self bugafishUpdate:bugafish];
}

- (void)addEnergyBar
{
    energyBar.position = ccp(60, 160);
    energyBar.contentSize = CGSizeMake(50, 10);
    [statusLayer addChild:energyBar];
    [energyBar startDrain];
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
    CGRect endRect = CGRectMake(bugafish.position.x + dx,
                                bugafish.position.y + dy,
                                bugafish.displayedFrame.rect.size.width,
                                bugafish.displayedFrame.rect.size.height);
    if(CGRectIntersectsRect(worldBounds, endRect))
    {
        CCAction *updateCall = [CCCallFuncN actionWithTarget:self selector:@selector(bugafishUpdate:)];
        [actions addObject:updateCall];
    }
    else
    {
        CCAction *removeCall = [CCCallFuncN actionWithTarget:self selector:@selector(bugafishRemove:)];
        [actions addObject:removeCall];
    }
    
    CCAction* bugaMove = [CCSequence actionsWithArray:actions];
    bugaMove.tag = bugaMoveActionTag;
    
    [bugafish runAction:bugaMove];
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

- (BOOL)bacCanMove
{
    // here will be checks for all actions and states which do not allow tap processing
    if ([bacilla getActionByTag:bacDappingActionTag]) return NO;
    return YES;
}

//--------------------------------------------------------------

- (void)bugafishRemove:(CCSprite*)buga
{
    CCSpriteBatchNode *bn = [[AnimationLoader sharedInstance] spriteBatchNodeWithName:@"Bugafish"];
    [bn removeChild:buga cleanup:YES];
}


- (void)dashBuga:(CCSprite*)buga
{
    // this is workaround
    // when collision is detected rects of buga and bacilla are intersecting
    // and they both couldn't move.
    buga.tag = bugaUntouchableTag;
    [self performSelector:@selector(makeBugaTouchable:) withObject:buga afterDelay:0.1];
    
    CGFloat angle = bacilla.rotation;
    if (bacilla.scaleX < 0) angle += 180;
    angle *= M_PI/180; // radians
    
    CGFloat dx;
    CGFloat dy;
    
    if (!bacDoublespeeded) {
        if (!canMakeStrongHit) {
            dx =  BugaWeakHitShortDist*cos(angle);
            dy = -BugaWeakHitShortDist*sin(angle);
        }
        else {
            dx =  BugaWeakHitLongDist*cos(angle);
            dy = -BugaWeakHitLongDist*sin(angle);
        }
    }
    else {
        if (!canMakeStrongHit) {
            dx =  BugaStrongHitShortDist*cos(angle);
            dy = -BugaStrongHitShortDist*sin(angle);
        }
        else {
            dx =  BugaStrongHitLongDist*cos(angle);
            dy = -BugaStrongHitLongDist*sin(angle);
            
            b2Vec2 v; // bacilla velocity vector
            v.Set( bacilla.scaleX*cos(CC_DEGREES_TO_RADIANS(bacilla.rotation)), 
                  -bacilla.scaleX*sin(CC_DEGREES_TO_RADIANS(bacilla.rotation)));
            
            b2Vec2 r; // direction from the bacilla's center to buga's center
            r.Set(buga.position.x - bacilla.position.x,
                  buga.position.y - bacilla.position.y);
            
            float rd = b2Cross(v, r); // vector mul between v and r - give the dir of rotation
            rd /= -fabsf(rd); // -1 or 1; minus - because positive rotation is conterclockwise
            
            // rotate with direction depending on relative position and bacilla's movement dir
            CGFloat currRot = (int)buga.rotation % 360;
            id rotation         = [CCRotateBy actionWithDuration:0.5 angle:rd*(180-currRot/4)];
            id repeatedRotation = [CCRepeat actionWithAction:rotation times:4];
            id eased            = [CCEaseSineOut actionWithAction:repeatedRotation];
            [buga runAction:eased];
        }
    }
    id move       = [CCMoveBy actionWithDuration:2 position:ccp(dx,dy)];
    id callUpdate = [CCCallFuncN actionWithTarget:self selector:@selector(bugafishUpdate:)];
    CCAction *all = [CCEaseSineOut actionWithAction:[CCSequence actions:move, callUpdate, nil]];
    all.tag = bugaDashedActionTag;
    
    [buga stopActionByTag:bugaDashedActionTag];
    [buga stopActionByTag:bugaMoveActionTag];
    [buga runAction:all];
}

- (void)makeBugaTouchable:(CCSprite*)buga
{
    buga.tag = bugaTouchableTag;
}


- (void)heroDapFromBuga:(CCSprite*)buga
{
    CGFloat angle = bacilla.rotation;
    if (bacilla.scaleX < 0) angle += 180;
    angle -= 180;       // direction opposite to the bacilla's move
    angle *= M_PI/180;  // radians
    CGFloat dx =  BacDapDist*cos(angle);
    CGFloat dy = -BacDapDist*sin(angle);
    
    id moveBackwards = [CCMoveBy actionWithDuration:BacDapTime position:ccp(dx, dy)];
    CCAction *easedMove = [CCEaseSineOut actionWithAction:moveBackwards];
    easedMove.tag = bacDappingActionTag;
    
    [bacilla stopActionByTag:bacMoveActionTag];
    [bacilla runAction:easedMove];
}
//--------------------------------------------------------------

#pragma mark - Touches methods

-(void)registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![self bacCanMove]) return;
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGFloat bScrX = bacilla.position.x + helloWorldLayer.position.x;
    CGFloat bScrY = bacilla.position.y + helloWorldLayer.position.y;
    
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
}

//--------------------------------------------------------------

- (void)update:(ccTime)dt
{
    [energyBar update:dt];
    
    for (CCSprite* buga in bugafishes)
    {
        if (buga.tag == bugaUntouchableTag) continue;
        
        if ([self collisionDetection:buga with:bacilla])
        {
            BOOL death = [self isHeroCanBeSeenBy:buga];
            if ([buga getActionByTag:bugaDashedActionTag] || !death)
            {
                [self dashBuga:buga];
            }
            else
            {
                //                [self gamover];
                NSLog(@"Death!");
                
                [self dashBuga:buga]; // debug
            }
            [self heroDapFromBuga:buga];
        }
    }
}

//--------------------------------------------------------------

- (BOOL)isHeroCanBeSeenBy:(CCSprite*)evilCreature
{
    // check direction towards hero and rotation of the creature
    return (bacilla.position.x - evilCreature.position.x - evilCreature.displayedFrame.rect.size.width/2)*evilCreature.scaleX > 0;
}

- (BOOL)collisionDetection:(CCSprite*)s1 with:(CCSprite*)s2
{
    // TODO: modify to handle different sprites, not only buga and bacilla
    // maybe create dictionary of polys with sprite's tag as Key
    b2Transform transform1;  b2Vec2 wPos1;
    b2Transform transform2;  b2Vec2 wPos2;
    wPos1.Set(SCREEN_TO_WORLD(s1.position.x), SCREEN_TO_WORLD(s1.position.y));
    wPos2.Set(SCREEN_TO_WORLD(s2.position.x), SCREEN_TO_WORLD(s2.position.y));
    CGFloat wAngle1 = COCOS_ROTATION_TO_B2_ANGLE(s1.rotation);
    CGFloat wAngle2 = COCOS_ROTATION_TO_B2_ANGLE(s2.rotation);
    if (s1.scaleX == -1) wAngle1 -= COCOS_ROTATION_TO_B2_ANGLE(180);
    if (s2.scaleX == -1) wAngle2 -= COCOS_ROTATION_TO_B2_ANGLE(180);
    transform1.Set(wPos1, wAngle1);
    transform2.Set(wPos2, wAngle2);
    
    b2PolygonShape *poly1 = NULL;
    b2PolygonShape *poly2 = NULL;
    if (s1.tag == bacTag) poly1 = bacPoly;
    if (s2.tag == bacTag) poly2 = bacPoly;
    if (s1.tag == bugaTouchableTag) poly1 = bugaPoly;
    if (s2.tag == bugaTouchableTag) poly2 = bugaPoly;
    
    b2Manifold manifold;
    b2CollidePolygons(&manifold, poly1, transform1, poly2, transform2);
    return (manifold.pointCount > 0);
}

//--------------------------------------------------------------
// energyBar delegate

- (void)energyBarZeroed:(EnergyBar *)eb
{
    if (eb == energyBar)
    {
        bacDoublespeeded = NO;
    }
}

//--------------------------------------------------------------

- (void) dealloc
{
    delete(bugaPoly);
    delete(bacPoly);
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	self.bacilla = nil;
    self.bacillaAnimation =nil;
    self.bacillaMoveAnimation = nil;
    self.background = nil;
    
    self.bugafishAnimation = nil;
    self.bugafishMoveAction = nil;
    
    self.bugafishes = nil;
    self.stars = nil;
    self.redPills = nil;
    self.greenPills = nil;
    
    self.prevTapTime = nil;
    
    self.energyBar = nil;
    
    self.helloWorldLayer = nil;
    self.statusLayer = nil;
    
	[super dealloc];
}

//- (void)draw
//{
// //DEBUG STUFF
//    CGPoint *bacV, *bugaV;
//    
//    int bacVCnt = bacPoly->GetVertexCount();
//    bacV = (struct CGPoint*)malloc(bacVCnt*sizeof(struct CGPoint));    
//    for (int i = 0; i<bacVCnt; i++)
//    {
//        b2Vec2 v = bacPoly->GetVertex(i);
//        bacV[i] = CGPointMake(bacilla.position.x + WORLD_TO_SCREEN(v.x), bacilla.position.y + WORLD_TO_SCREEN(v.y));
//    }
//    
//    ccDrawPoly(bacV, bacVCnt, YES);
//    free(bacV);
//    
//    
//    CCSprite *buga = [bugafishes objectAtIndex:0];
//    int bugaVCnt = bugaPoly->GetVertexCount();
//    bugaV = (struct CGPoint*)malloc(bugaVCnt*sizeof(struct CGPoint));
//    
//    for (int i = 0; i<bugaVCnt; i++)
//    {
//        b2Vec2 v = bugaPoly->GetVertex(i);
//        bugaV[i] = CGPointMake(buga.position.x + WORLD_TO_SCREEN(v.x), buga.position.y + WORLD_TO_SCREEN(v.y));
//    }
//    
//    ccDrawPoly(bugaV, bugaVCnt, YES);
//    free(bugaV);
//}
@end
