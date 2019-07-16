//
//  DustEffect.m
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 15..
//  Copyright 2011 Student. All rights reserved.
//

#import "DiffusionEffect.h"

#define AppearSpeed 0.1f

@implementation DiffusionEffect

-(id)initWithFileAndTimes:(NSString *)filePath_ Begin:(float)begin_ Delay:(float)delay_ Restart:(float)restart_ DiffusionSpeed:(float)diffusionSpeed_ DiffusionScale:(float)diffusionScale_ {
	if ( (self = [super init] )) {
		//Texture Setting
		[self setTexture:[[CCTextureCache sharedTextureCache] addImage:filePath_]];
		[self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
		self.anchorPoint = ccp(0.5f,0.5f);
		
		et = 0;
		transitionScale = 0;
		begin = begin_;
		delay = delay_;
		restart = restart_;
		diffusionSpeed = diffusionSpeed_;
		diffusionScale = diffusionScale_;
		runEffect = YES;
		beginScale = 1;
        [self setBeginOpacity:255];
	}
	return self;
}

-(void)update:(ccTime)d_ {
	et += d_;
	if (et > begin) {
		if (runEffect) {
			transitionScale += diffusionSpeed * d_;
			self.scale = beginScale + transitionScale;
			
			if (self.scale >= diffusionScale) {
				runEffect = NO;
				endEffectTime = et;
				
				//NSLog(@"end scale:%f",self.scale);
			}else {
				transitionOpacity = 255-(transitionScale/(diffusionScale - beginScale))*255;
				                
                if (((diffusionScale-beginScale)/diffusionSpeed)*AppearSpeed > (et-begin) ) { //처음 10%의 시간동안은 나타는 모션
                    float subOpa = ((et-begin)/(((diffusionScale-beginScale)/diffusionSpeed)*AppearSpeed))*beginOpacity;
                    //NSLog(@"subOpa:%f seconds:%f",(((diffusionScale-beginScale)/diffusionSpeed)*0.1f),(et-begin));
                    //NSLog(@"subOpa:%f",subOpa);
                    self.opacity = subOpa;
                }else{
                    self.opacity = transitionOpacity;

                }
				//NSLog(@"scale:%f",self.scale);
			}
		}
	}
	
	if (restart != -1 && et >= restart) {
		[self restartEffect];
	}
	
	if (!runEffect) {
		if (delay != -1 &&  et - endEffectTime >= delay ) {
			[self repeatEffect];
		}
	}
	
}

-(void)setBeginScale:(float)scale_ {
	self.scale = scale_;
	beginScale = scale_;
}

-(void)setBeginOpacity:(float)beginOpacity_ {
	self.opacity = beginOpacity_;
	beginOpacity = beginOpacity_;
}

-(void)repeatEffect {
	runEffect = YES;
	et = begin;
	endEffectTime = 0;
	transitionScale = 0;
	//self.scale = beginScale;
	//self.opacity = 255;
}

-(void)restartEffect{
	runEffect = YES;
	et = 0;
	endEffectTime = 0;
	transitionScale = 0;
}
@end
