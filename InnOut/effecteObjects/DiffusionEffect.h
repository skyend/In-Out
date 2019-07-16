//
//  DiffusionEffect.h
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 15..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DiffusionEffect : CCSprite {

	float et; //ElapsedTime
	float transitionScale;
	float begin;
	float delay;
	float restart;
	float diffusionSpeed;
	float diffusionScale;
	float beginScale;
	float beginOpacity;
	BOOL  runEffect;
	float endEffectTime;
    
    float transitionOpacity;
}

-(id)initWithFileAndTimes:(NSString*)filePath_ Begin:(float)begin_ Delay:(float)delay_ Restart:(float)restart_ DiffusionSpeed:(float)diffusionSpeed_ DiffusionScale:(float)diffusionScale_; 
-(void)update:(ccTime)d_;
-(void)setBeginScale:(float)scale_;
-(void)setBeginOpacity:(float)beginOpacity_;
-(void)repeatEffect;
-(void)restartEffect;

@end
