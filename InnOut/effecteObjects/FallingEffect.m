//
//  FallingEffect.m
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 15..
//  Copyright 2011 Student. All rights reserved.
//

#import "FallingEffect.h"
#import "DiffusionEffect.h"


@implementation FallingEffect
@synthesize runReceiver;

-(id)initWithFileAndTime:(NSString *)filePath_ Begin:(float)begin_ Delay:(float)delay_ Restart:(float)restart_ FallingSpeed:(float)fallingSpeed_ _Duration:(float)duration_{
	if ( (self = [super init] )) {
		//Texture Setting
		[self setTexture:[[CCTextureCache sharedTextureCache] addImage:filePath_]];
		[self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
		self.anchorPoint = ccp(0.5f,0.5f);
		
		
		begin = begin_;
		delay = delay_;
		restart = restart_;
		fallingSpeed = fallingSpeed_;
		duration = duration_;
		
		et = 0;
		endTime = 0;
		acceleration = 0;
		runEffect = YES;
		
		self.opacity = 0;
	}
	return self;
}

-(void)update:(ccTime)d {
	et += d;
	
	if (runEffect) {
		if (et >= begin) {
			self.position = ccp(self.position.x , self.position.y - (fallingSpeed + acceleration) * d);
			acceleration += 9.8f;
			
			self.opacity = 255;
			
			//NSLog(@"aa");
			if (et-begin >= duration) {
				runEffect = NO;
				endTime = et;
			}
		}
	}
	
	if (restart != -1) {
		if (et >= restart) {
			[self restartEffect];
		}
	}
	if (!runEffect) {
		if (delay != -1) {
			if (et-endTime >= delay) {
				[self repeatEffect];
			}
		}
	}
	
	
}

-(void)restartEffect {
	self.position = beginPosition;
	et = 0;
	endTime = 0;
	runEffect = YES;
	acceleration = 0;
	
	if (runReceiver != nil) {
		[runReceiver repeatEffect];
	}
}

-(void)repeatEffect{
	self.position = beginPosition;
	et = begin-0.2f;
	endTime = 0;
	runEffect = YES;
	acceleration = 0;
	
	if (runReceiver != nil) {
		[runReceiver repeatEffect];
	}
}


-(void)setBeginPosition:(CGPoint)pos_{
	self.position = pos_;
	beginPosition = pos_;
}

@end
