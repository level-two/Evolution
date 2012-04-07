//
//  AnimationLoader.m
//  Evolution
//
//  Created by lev on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationLoader.h"

@interface AnimationLoader ()
 @property (nonatomic, retain) NSMutableDictionary *animations;
 @property (nonatomic, retain) NSMutableDictionary *spriteBathcNodes;
@end


@implementation AnimationLoader
 @synthesize spriteBathcNodes;
 @synthesize animations;

//---------Singleton methods--------------------

+ (AnimationLoader*)sharedInstance
{
    static AnimationLoader *shared = nil;

    if (shared == nil)
    {
        @synchronized([AnimationLoader class])
        {
            shared = [[AnimationLoader alloc] init];
        }
    }
    return shared;
}

- (id) retain
{
    return self;
}

- (oneway void) release
{
    // Does nothing here.
}

- (id) autorelease
{
    return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}

//---------Class methods--------------------

- (id)init
{
    if ((self = [super init]))
    {
        self.animations = [NSMutableDictionary dictionary];
        self.spriteBathcNodes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)loadAnimationsFromDir:(NSString *)dir recursive:(BOOL)recursive
{
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * documentsPath = [resourcePath stringByAppendingPathComponent:dir];
    
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    NSLog(@"%@", directoryContents);
    BOOL result = YES;
    for (NSString *file in directoryContents)
    {
        NSString *path = [documentsPath stringByAppendingPathComponent:file];
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
        
        if (isDir && recursive)
        {
            result &= [self loadAnimationsFromDir:path recursive:YES];
        }
        else 
        {
            if ([file hasSuffix:@".plist"])
                result &= [self loadAnimationsFromFile:path];
        }
        if (!result) break;
    }
    return result;
}

- (BOOL)loadAnimationsFromFile:(NSString *)plistFile
{
    if (![plistFile hasSuffix:@".plist"])
        return NO;
    
    NSString *pngFile = [plistFile stringByReplacingOccurrencesOfString:@".plist" withString:@".png"];
    NSString *spriteName = [[plistFile lastPathComponent] stringByReplacingOccurrencesOfString:@".plist" withString:@""];
    
    // check whether loaded yet
    if ([spriteBathcNodes objectForKey:spriteName]) 
        return YES;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFile];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:pngFile];
    if (spriteSheet == nil) 
        return NO;
    
    NSDictionary *plistDic = [[[NSDictionary alloc] initWithContentsOfFile:plistFile] autorelease];
    if (plistDic == nil) 
        return NO;
    
    NSDictionary *framesInfoDic = [plistDic objectForKey:@"AnimationInfo"];
    if (framesInfoDic.count == 0) 
        return NO;
    
    for (NSString *frameName in [framesInfoDic allKeys])
    {
        int frameCount = [[[framesInfoDic objectForKey:frameName] objectForKey:@"FrameCount"] intValue];
        NSMutableArray *frames = [NSMutableArray array];
        
        for (int i = 0; i < frameCount; i++)
        {
            NSString *spriteFileName = [NSString stringWithFormat:@"%@_%d.png",frameName,i];
            CCSpriteFrame *sf = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFileName];
            if (sf == nil) 
                return NO;
            [frames addObject:sf];
        }
        
        CCAnimation *anim = [CCAnimation animationWithFrames:frames delay:0.1f];
        [animations setObject:anim forKey:frameName];
    }
    
    [spriteBathcNodes setObject:spriteSheet forKey:spriteName];
    
    return YES;
}

//------------------------------------------------

- (CCSpriteBatchNode*)spriteBatchNodeWithName:(NSString*)spriteBatchNodeName {
    return [spriteBathcNodes objectForKey:spriteBatchNodeName];
}

- (NSArray*)allSpriteBatchNodes {
    return [spriteBathcNodes allValues];
}

- (CCAnimation*)animationWithName:(NSString*)animationName {
    return [animations objectForKey:animationName];
}

- (CCSprite*)spriteWithName:(NSString*)spriteName {
    return [CCSprite spriteWithSpriteFrameName:[spriteName stringByAppendingString:@"_0.png"]];
}

- (CCSprite*)spriteWithName:(NSString*)spriteName frameNumber:(int)frameNum {
    return [CCSprite spriteWithSpriteFrameName:[spriteName stringByAppendingFormat:@"_%d.png",frameNum]];
}

//------------------------------------------------

- (void)dealloc
{
    self.animations = nil;
    self.spriteBathcNodes = nil;
    [super dealloc];
}

@end
