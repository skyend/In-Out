//
//  NodeTweener.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 23..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"

typedef enum {
	LIFEDOWN
}behaviorType;

typedef enum {
	FADE_IN,
	FADE_OUT,
	BASIC
}Ani_Type;


@interface TweenerBase : DynamicObject {
	CCNode  * field;
	
	BOOL	running;
	int		totalRunSwitchCounter;
	int		maxOnRunSwitchSave;
	
	CGFloat runningTime;
	
	CGPoint  beginPos;
	CGPoint	 targetPos;
	CGFloat  PosAnitime;
	CGPoint  stepPos;
	Ani_Type posAniType;
	BOOL	 enablePosAni;
	
	// 0~1
	// default: 1
	CGPoint  beginScale;
	CGPoint  targetScale;
	CGFloat  ScaleAnitime;
	CGPoint  stepScale;
	Ani_Type scaleAniType;
	BOOL	 enableScaleAni;
	
	// 0~360
	CGFloat  beginRotate;
	CGFloat  targetRotate;
	CGFloat  RotateAnitime;
	CGFloat  stepRotate;
	Ani_Type rotateAniType;
	BOOL     enableRotateAni;
	
	//CGFloat opacity;
	// 0~255
	// default: 255
	CGFloat  beginOpacity;
	CGFloat  targetOpacity;
	CGFloat  OpacityAnitime;
	CGFloat  stepOpacity;
	CGFloat  skipedOpacity;
	Ani_Type opacityAniType;
	BOOL	 enableOpacityAni;
}



@end

//Sprite Tweener
@interface NodeTweener : TweenerBase {
	
	CCSprite  * target;
}

-(id)initWithTarget:(CCNode*)target_ field:(CCNode*)field_;
-(id)initWithTargetAndTag:(CCNode*)target_ tag:(int)_tag field:(CCNode*)field_;

-(void)setTweeningPos:(CGPoint)targetPos_ setTime:(CGFloat)time_;
-(void)setTweeningScale:(CGPoint)targetScale_ setTime:(CGFloat)time_;
-(void)setTweeningRotate:(CGFloat)targetRotate_ setTime:(CGFloat)time_;
-(void)setTweeningOpacity:(CGFloat)targetOpacity_ setTime:(CGFloat)time_;

-(void)start;
-(void)pause;
-(void)restartTweening;
-(void)update:(ccTime)delta;
-(void)removeTween;
-(void)dealloc;

@end


@interface AtlasNodeTweener : TweenerBase {

	CCLabelAtlas  * target;
}

-(id)initWithTarget:(CCNode*)target_ field:(CCNode*)field_;
-(id)initWithTargetAndTag:(CCNode*)target_ tag:(int)_tag field:(CCNode*)field_;

-(void)setTweeningPos:(CGPoint)targetPos_ setTime:(CGFloat)time_;
-(void)setTweeningScale:(CGPoint)targetScale_ setTime:(CGFloat)time_;
-(void)setTweeningRotate:(CGFloat)targetRotate_ setTime:(CGFloat)time_;
-(void)setTweeningOpacity:(CGFloat)targetOpacity_ setTime:(CGFloat)time_;

-(void)start;
-(void)pause;
-(void)restartTweening;
-(void)update:(ccTime)delta;
-(void)removeTween;
-(void)dealloc;
@end

//CCNode  * field;
//CCSprite  * target;
////CCLabelAtlas 
////CCLayer * wrapedTarget; //투명도가 들어가는 애니메이션일 경우 
//
//BOOL	running;
//int		totalRunSwitchCounter;
//int		maxOnRunSwitchSave;
//
//CGFloat runningTime;
//
//CGPoint  beginPos;
//CGPoint	 targetPos;
//CGFloat  PosAnitime;
//CGPoint  stepPos;
//Ani_Type posAniType;
//BOOL	 enablePosAni;
//
//// 0~1
//// default: 1
//CGPoint  beginScale;
//CGPoint  targetScale;
//CGFloat  ScaleAnitime;
//CGPoint  stepScale;
//Ani_Type scaleAniType;
//BOOL	 enableScaleAni;
//
//// 0~360
//CGFloat  beginRotate;
//CGFloat  targetRotate;
//CGFloat  RotateAnitime;
//CGFloat  stepRotate;
//Ani_Type rotateAniType;
//BOOL     enableRotateAni;
//
////CGFloat opacity;
//// 0~255
//// default: 255
//CGFloat  beginOpacity;
//CGFloat  targetOpacity;
//CGFloat  OpacityAnitime;
//CGFloat  stepOpacity;
//CGFloat  skipedOpacity;
//Ani_Type opacityAniType;
//BOOL	 enableOpacityAni;
//}
//
//
//-(id)initWithTarget:(CCNode*)target_ field:(CCNode*)field_;
//-(id)initWithTargetAndTag:(CCNode*)target_ tag:(int)_tag field:(CCNode*)field_;
//
//-(void)setTweeningPos:(CGPoint)targetPos_ setTime:(CGFloat)time_;
//-(void)setTweeningScale:(CGPoint)targetScale_ setTime:(CGFloat)time_;
//-(void)setTweeningRotate:(CGFloat)targetRotate_ setTime:(CGFloat)time_;
//-(void)setTweeningOpacity:(CGFloat)targetOpacity_ setTime:(CGFloat)time_;
//
//-(void)start;
//-(void)pause;
//-(void)restartTweening;
//-(void)update:(ccTime)delta;
//-(void)removeTween;
//-(void)dealloc;
