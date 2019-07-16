//
//  FallingEffect.h
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 15..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class DiffusionEffect;

@interface FallingEffect : CCSprite {
	float begin;
	float delay;
	float restart;
	float fallingSpeed;
	float acceleration;
	float duration;
	CGPoint beginPosition;
	DiffusionEffect * runReceiver;
	
	BOOL runEffect;
	float et;
	float endTime;
	
	
}
-(id)initWithFileAndTime:(NSString*)filePath_ Begin:(float)begin_ Delay:(float)delay_ Restart:(float)restart_ FallingSpeed:(float)fallingSpeed_ _Duration:(float)duration_;
-(void)update:(ccTime)d;
-(void)restartEffect;
-(void)repeatEffect;
-(void)setBeginPosition:(CGPoint)pos_;

@property (assign) DiffusionEffect * runReceiver;

@end
