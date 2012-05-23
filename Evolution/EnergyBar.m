//
//  EnergyBar.m
//  Evolution
//
//  Created by lev on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnergyBar.h"

@interface EnergyBar ()
 @property (nonatomic, assign) BOOL drain;
 -(void)drawFilledRectWith:(CGPoint)v1 and:(CGPoint)v2;
@end

@implementation EnergyBar
 @synthesize value;
 @synthesize delegate;
 @synthesize regenerationSpeed;
 @synthesize drainSpeed;
 @synthesize rect;
 @synthesize drain;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

+(EnergyBar*)createWithDrainSpeed:(CGFloat)ds regenerationSpeed:(CGFloat)rs rect:(CGRect)r
{
    EnergyBar *eb = [[[EnergyBar alloc] init] autorelease];
    eb.regenerationSpeed = rs;
    eb.drainSpeed = ds;
    eb.rect = r;
    return eb;
}

-(void)update:(ccTime)dt
{
    if (drain)
    {
        value -= dt*drainSpeed;
        if (value < 0)
        {
            value = 0;
            drain = NO;
            if ([delegate respondsToSelector:@selector(energyBarZeroed:)])
                [delegate energyBarZeroed:self];
        }
    }
    else
    {
        value += dt*regenerationSpeed;
        if (value > 1) value = 1;
    }
}

-(void)startDrain
{
    drain = YES;
}

-(void)stopDrain
{
    drain = NO;
}

-(void)drawInLayer:(CCLayer *)l
{
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 0, 255, 255);
    glLineWidth(2);
    
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGFloat k = self.value;
    
    [self drawFilledRectWith:ccp(x,y) and:ccp(x+w*k,y+h)];
    
    glColor4ub(0, 0, 0, 255);
    CGPoint vertices2[] = {ccp(x,y), ccp(x+w,y), ccp(x+w,y+h), ccp(x,y+h)};
    ccDrawPoly(vertices2, 4, YES);
}

-(void)drawFilledRectWith:(CGPoint)v1 and:(CGPoint)v2
{
	CGPoint poli[]={v1,CGPointMake(v1.x,v2.y),v2,CGPointMake(v2.x,v1.y)};
    
    CC_DISABLE_DEFAULT_GL_STATES()
    
	glVertexPointer(2, GL_FLOAT, 0, poli);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    CC_ENABLE_DEFAULT_GL_STATES()
}


- (void)dealloc
{
    [super dealloc];
}

@end
