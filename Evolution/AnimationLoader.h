//
//  AnimationLoader.h
//  Evolution
//
//  Created by lev on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface AnimationLoader : NSObject

+ (AnimationLoader*)sharedInstance;

- (BOOL)loadAnimationsFromFile:(NSString*)filename;
- (BOOL)loadAnimationsFromDir:(NSString*)dir recursive:(BOOL)recursive;

- (NSArray*)allSpriteBatchNodes;
- (CCSpriteBatchNode*)spriteBatchNodeWithName:(NSString*)spriteBatchNodeName;
- (CCAnimation*)animationWithName:(NSString*)animationName;
- (CCSprite*)spriteWithName:(NSString*)spriteName;
- (CCSprite*)spriteWithName:(NSString*)spriteName frameNumber:(int)frameNum;

@end
