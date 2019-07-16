//
//  NodeTweener.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 23..
//  Copyright 2011 Student. All rights reserved.
//

#import "NodeTweener.h"

@implementation TweenerBase

@end


@implementation NodeTweener

-(id)initWithTarget:(CCNode*)target_ field:(CCNode*)field_ {
	
	if ( (self = [super init] ) ) {
		
		target = (CCSprite*)target_;
		field  = field_;
		
		beginPos = [target position];
		beginScale = ccp([target scaleX],[target scaleY]);
		beginOpacity = target.opacity;
		beginRotate = [target rotation];
		
		enableOpacityAni	= FALSE;
		enableRotateAni		= FALSE;
		enablePosAni		= FALSE;
		enableScaleAni		= FALSE;
		
		running				= FALSE;
		totalRunSwitchCounter= 0;
		maxOnRunSwitchSave = 0;
		
		[field addChild:target];
		
	}else {
		return nil;
	}
	NSLog(@"NodeTweener Initialize");
	return self;
}


-(id)initWithTargetAndTag:(CCNode*)target_ tag:(int)_tag field:(CCNode*)field_ {
	
	self = [self initWithTarget:target_ field:field_];
	
	[field removeChild:[target_ retain]cleanup:NO];
	[field addChild:[target autorelease] z:_tag tag:_tag];
	
	return self;
}

-(void)setTweeningPos:(CGPoint)targetPos_ setTime:(CGFloat)time_{
	
	if (!enablePosAni) { //최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetPos = targetPos_;
	PosAnitime = time_;
	enablePosAni = TRUE;
	
	stepPos = CGPointMake(targetPos.x - beginPos.x, targetPos.y - beginPos.y);
	stepPos = ccp(stepPos.x/PosAnitime, stepPos.y/PosAnitime);
	
	
}

-(void)setTweeningScale:(CGPoint)targetScale_ setTime:(CGFloat)time_{
	
	if (!enableScaleAni) {//최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetScale = targetScale_;
	ScaleAnitime = time_;
	enableScaleAni = TRUE;
	
	stepScale = CGPointMake(targetScale.x - beginScale.x, targetScale.y - beginScale.y);
	stepScale = ccp(stepScale.x/ScaleAnitime,stepScale.y/ScaleAnitime);
	
	
	
}

-(void)setTweeningRotate:(CGFloat)targetRotate_ setTime:(CGFloat)time_{
	
	if (!enableRotateAni) {//최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetRotate = targetRotate_;
	RotateAnitime = time_;
	enableRotateAni = TRUE;
	
	stepRotate = targetRotate - beginRotate;
	stepRotate = stepRotate	/ RotateAnitime;
	
	
}


-(void)setTweeningOpacity:(CGFloat)targetOpacity_ setTime:(CGFloat)time_{
	
	if (!enableOpacityAni) {//최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetOpacity = targetOpacity_;
	OpacityAnitime = time_;
	enableOpacityAni = TRUE;
	
	/*
	 if (wrapedTarget == nil) {
	 //[[target retain] autorelease];
	 [field removeChild:target cleanup:NO];
	 
	 wrapedTarget = [[CCLayer alloc] init];
	 [wrapedTarget addChild:target];
	 
	 [field addChild:wrapedTarget];
	 }*/
	
	stepOpacity = targetOpacity - beginOpacity;
	stepOpacity = stepOpacity / OpacityAnitime;
	
	
	
}

-(void)start {
	if (running) {
		[self restartTweening];
	}else {
		running = TRUE;
		target.visible = TRUE;
	}
}

-(void)pause {
	running = FALSE;
}

-(void)restartTweening { //처음부터 다시
	target.visible = TRUE;
	runningTime = 0;
	running = TRUE;
	
	target.position = beginPos;
	target.opacity = beginOpacity;
	target.rotation = beginRotate;
	target.scaleX = beginScale.x;
	target.scaleY = beginScale.y;
	
	totalRunSwitchCounter = maxOnRunSwitchSave;
	
}

-(void)update:(ccTime)delta {
	if (running) {
		
		runningTime += delta;
		
		if (enablePosAni) {
			
			if (runningTime < PosAnitime) {
				target.position = ccp(target.position.x + stepPos.x*delta, target.position.y + stepPos.y*delta);
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		if (enableScaleAni) {
			if (runningTime < ScaleAnitime) {
				target.scaleX = target.scaleX + stepScale.x * delta;
				target.scaleY = target.scaleY + stepScale.y * delta;
				
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		if (enableRotateAni) {
			
			if (runningTime < RotateAnitime) {
				target.rotation = target.rotation + stepRotate * delta;
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		if (enableOpacityAni) {
			if (runningTime < OpacityAnitime) {
				
				
				skipedOpacity += (float)stepOpacity*delta;
				
				target.opacity += (int)skipedOpacity;
				skipedOpacity -= (int)skipedOpacity;
				
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		
		if (totalRunSwitchCounter == 0) {
			//running = FALSE;
		}
	}
	
	
	
}

-(void)removeTween{
	
	enableOpacityAni	= FALSE;
	enableRotateAni		= FALSE;
	enablePosAni		= FALSE;
	enableScaleAni		= FALSE;
	
	running				= FALSE;
	totalRunSwitchCounter = 0;
	maxOnRunSwitchSave = 0;
	
	[field removeChild:target cleanup:YES];
}



-(void)dealloc {
	[self removeTween];
	[super dealloc];
	NSLog(@"NodeTweener Dealloc");
}

@end


@implementation AtlasNodeTweener

-(id)initWithTarget:(CCNode*)target_ field:(CCNode*)field_ {
	
	if ( (self = [super init] ) ) {
		
		target = (CCLabelAtlas*)target_;
		field  = field_;

		beginPos = [target position];
		beginScale = ccp([target scaleX],[target scaleY]);
		beginOpacity = target.opacity;
		beginRotate = [target rotation];
		
		enableOpacityAni	= FALSE;
		enableRotateAni		= FALSE;
		enablePosAni		= FALSE;
		enableScaleAni		= FALSE;
		
		running				= FALSE;
		totalRunSwitchCounter= 0;
		maxOnRunSwitchSave = 0;
		
		[field addChild:target];
		
	}else {
		return nil;
	}
	NSLog(@"AtlasNodeTweener Initialize");
	return self;
}


-(id)initWithTargetAndTag:(CCNode*)target_ tag:(int)_tag field:(CCNode*)field_ {
	
	if ( (self = [super init] ) ) {
		
		target = (CCLabelAtlas*)target_;
		field  = field_;
		
		beginPos = [target position];
		beginScale = ccp([target scaleX],[target scaleY]);
		beginOpacity = target.opacity;
		beginRotate = [target rotation];
		
		enableOpacityAni	= FALSE;
		enableRotateAni		= FALSE;
		enablePosAni		= FALSE;
		enableScaleAni		= FALSE;
		
		running				= FALSE;
		totalRunSwitchCounter= 0;
		maxOnRunSwitchSave = 0;
		
		[field addChild:target z:_tag tag:_tag];
		
	}else {
		return nil;
	}

	
	return self;
}

-(void)setTweeningPos:(CGPoint)targetPos_ setTime:(CGFloat)time_{
	
	if (!enablePosAni) { //최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetPos = targetPos_;
	PosAnitime = time_;
	enablePosAni = TRUE;
	
	stepPos = CGPointMake(targetPos.x - beginPos.x, targetPos.y - beginPos.y);
	stepPos = ccp(stepPos.x/PosAnitime, stepPos.y/PosAnitime);
	
	
}

-(void)setTweeningScale:(CGPoint)targetScale_ setTime:(CGFloat)time_{
	
	if (!enableScaleAni) {//최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetScale = targetScale_;
	ScaleAnitime = time_;
	enableScaleAni = TRUE;
	
	stepScale = CGPointMake(targetScale.x - beginScale.x, targetScale.y - beginScale.y);
	stepScale = ccp(stepScale.x/ScaleAnitime,stepScale.y/ScaleAnitime);
	
	
	
}

-(void)setTweeningRotate:(CGFloat)targetRotate_ setTime:(CGFloat)time_{
	
	if (!enableRotateAni) {//최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetRotate = targetRotate_;
	RotateAnitime = time_;
	enableRotateAni = TRUE;
	
	stepRotate = targetRotate - beginRotate;
	stepRotate = stepRotate	/ RotateAnitime;
	
	
}


-(void)setTweeningOpacity:(CGFloat)targetOpacity_ setTime:(CGFloat)time_{
	
	if (!enableOpacityAni) {//최초 한번만 카운터를 증가시킴
		totalRunSwitchCounter ++;
		maxOnRunSwitchSave++;
	}
	
	targetOpacity = targetOpacity_;
	OpacityAnitime = time_;
	enableOpacityAni = TRUE;
	
	/*
	 if (wrapedTarget == nil) {
	 //[[target retain] autorelease];
	 [field removeChild:target cleanup:NO];
	 
	 wrapedTarget = [[CCLayer alloc] init];
	 [wrapedTarget addChild:target];
	 
	 [field addChild:wrapedTarget];
	 }*/
	
	stepOpacity = targetOpacity - beginOpacity;
	stepOpacity = stepOpacity / OpacityAnitime;
	
	
	
}

-(void)start {
	if (running) {
		[self restartTweening];
	}else {
		running = TRUE;
		target.visible = TRUE;
	}
}

-(void)pause {
	running = FALSE;
}

-(void)restartTweening { //처음부터 다시
	target.visible = TRUE;
	runningTime = 0;
	running = TRUE;
	
	target.position = beginPos;
	target.opacity = beginOpacity;
	target.rotation = beginRotate;
	target.scaleX = beginScale.x;
	target.scaleY = beginScale.y;
	
	totalRunSwitchCounter = maxOnRunSwitchSave;
	
}

-(void)update:(ccTime)delta {
	if (running) {
		
		runningTime += delta;
		
		if (enablePosAni) {
			
			if (runningTime < PosAnitime) {
				target.position = ccp(target.position.x + stepPos.x*delta, target.position.y + stepPos.y*delta);
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		if (enableScaleAni) {
			if (runningTime < ScaleAnitime) {
				target.scaleX = target.scaleX + stepScale.x * delta;
				target.scaleY = target.scaleY + stepScale.y * delta;
				
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		if (enableRotateAni) {
			
			if (runningTime < RotateAnitime) {
				target.rotation = target.rotation + stepRotate * delta;
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		if (enableOpacityAni) {
			if (runningTime < OpacityAnitime) {
				
				
				skipedOpacity += (float)stepOpacity*delta;
				
				target.opacity += (int)skipedOpacity;
				skipedOpacity -= (int)skipedOpacity;
				
			}else {
				totalRunSwitchCounter--;
			}
			
		}
		
		if (totalRunSwitchCounter == 0) {
			//running = FALSE;
		}
	}
	
	
	
}

-(void)removeTween{
	
	enableOpacityAni	= FALSE;
	enableRotateAni		= FALSE;
	enablePosAni		= FALSE;
	enableScaleAni		= FALSE;
	
	running				= FALSE;
	totalRunSwitchCounter = 0;
	maxOnRunSwitchSave = 0;
	
	[field removeChild:target cleanup:YES];
}



-(void)dealloc {
	[self removeTween];
	[super dealloc];
	NSLog(@"AtlasNodeTweener Dealloc");
}

@end
