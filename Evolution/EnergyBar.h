//
//  EnergyBar.h
//  Evolution
//
//  Created by lev on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class EnergyBar;

@protocol EnergyBarDelegate <NSObject>
 -(void)energyBarZeroed:(EnergyBar*)eb;
@end


@interface EnergyBar : CCNode
 @property (nonatomic, readonly) CGFloat value;
 @property (nonatomic, assign) id<EnergyBarDelegate> delegate;
 @property (nonatomic, assign) CGFloat regenerationSpeed;
 @property (nonatomic, assign) CGFloat drainSpeed;

 +(EnergyBar*)createWithDrainSpeed:(CGFloat)ds regenerationSpeed:(CGFloat)rs;
 -(void)startDrain;
 -(void)stopDrain;

 -(void)update:(ccTime)dt;
@end
