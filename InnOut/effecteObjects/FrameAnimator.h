//
//  FrameAnimator.h
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 15..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FrameAnimator : CCSprite {
	float et;
	float endEt;
	
	int FPS;
	NSMutableArray * frameRects;
	float begin;
	float delay;
	float restart;
	
	BOOL runAni;
	BOOL endFrameAni;
	int currentFrame;
	float runEt;
	
	BOOL Gambbak;
}
-(id)initWithAnimationSheet:(NSString*)filePath_ FrameMap:(NSString*)map_ FrameLength:(int)frameLength_ FrameSize:(CGSize)frameSize_ _FPS:(int)FPS_ Begin:(float)begin_ Delay:(float)delay_ Restart:(float)restart_; 
-(void)update:(ccTime)d;

-(void)restartAni;
-(void)repeatAni;
-(void)noGambbak;
@end
