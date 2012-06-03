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
 @synthesize drain;


+(EnergyBar*)createWithDrainSpeed:(CGFloat)ds regenerationSpeed:(CGFloat)rs
{
    EnergyBar *eb = [[[EnergyBar alloc] init] autorelease];
    eb.regenerationSpeed = rs;
    eb.drainSpeed = ds;
    return eb;
}

-(id)init
{
    if (self = [super init])
    {
        value = 1.0;
    }
    return self;
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

-(void)draw
{
    CGFloat x = - self.contentSize.width/2;
    CGFloat y = - self.contentSize.height/2;
    CGFloat w = self.contentSize.width;
    CGFloat h = self.contentSize.height;
    CGFloat k = value;
    
    glEnable(GL_LINE_SMOOTH);
//    glLineWidth(2);
    
    glColor4ub(255, 0, 255, 255);
    CGPoint poly1[]= {ccp(x,y), ccp(x+w*k,y), ccp(x+w*k,y+h), ccp(x,y+h)};
    ccFillPoly(poly1, 4, YES);
    
    glColor4ub(255, 255, 255, 255);
	CGPoint poly[] = {ccp(x,y), ccp(x+w,y),   ccp(x+w,y+h),   ccp(x,y+h)};
    ccDrawPoly(poly, 4, YES);
}

-(void)dealloc
{
    [super dealloc];
}

@end
