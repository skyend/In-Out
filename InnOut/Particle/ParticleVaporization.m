//
//  ParticleCircle.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 29..
//  Copyright 2011 Student. All rights reserved.
//

#import "ParticleVaporization.h"
#import "ParticleManager.h"
/*
float floatMarkOut(float v) {
	if (v < 0) {
		return v * -1;
	}else {
		return v;
	}
}*/

@implementation ParticleVaporization


-(id)initWithKind:(ParticleImgCode)code_ myManager:(ParticleManager*)MyManager_{
	if ( (self = [super init] ) ){
		MyManager = MyManager_;
		
		CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"particle_%d.png",code_]];
		[tex setAliasTexParameters];
		
		
		
		CGRect rect = CGRectZero;
		rect.size = tex.contentSize;
		
		[self setTexture:tex];
		[self setTextureRect:rect];
		
		self.anchorPoint = ccp(0.5f,0.5f);
		
		recycleScope = [MyManager createScope];
		self.position = ccp(recycleScope.origin.x+(rand()%(int)recycleScope.size.width),recycleScope.origin.y + (rand()%(int)recycleScope.size.height));
		
		tp = ccp(self.position.x , 180 + (rand()%20));
		elapsedTime = 0;
		
		activated = NO;
		self.opacity = 0;
	}
	NSLog(@"ParticleVaporization Initialize");
	return self;
}


-(void)update:(ccTime)dt {
	if (activated) {
		elapsedTime += dt;
		
		self.position = ccp(self.position.x ,self.position.y + ((0.01f * (tp.y - self.position.y))));
		
		if (self.position.y - tp.y < 0.0001f) {
			tp = ccp(tp.x,tp.y+20);
		}
		
		if (self.position.y > 320) {
			self.position = ccp(recycleScope.origin.x+(rand()%(int)recycleScope.size.width),recycleScope.origin.y + (rand()%(int)recycleScope.size.height));
			tp = ccp(self.position.x , 180 + (rand()%20));

			elapsedTime = 0;
			
			if (MyManager.maintainParticleNum < MyManager.activatedParticleCount) {
				[self unActivate];
			}
		}
	}else {
		if (MyManager.maintainParticleNum > MyManager.activatedParticleCount) {
			[self activate];
			
		}
	}
	
}

-(void)activate {
	if (activated == NO) {
		activated = YES;
		NSLog(@"opacity:%d",MyManager.beginOpacity);
		self.opacity = MyManager.beginOpacity;
		MyManager.activatedParticleCount++;
	}
}

-(void)unActivate {
	if (activated == YES) {
		activated = NO;
		self.opacity = 0;
		MyManager.activatedParticleCount--;
	}
	
}
	
-(void)dealloc {
	
	[super dealloc];
	NSLog(@"ParticleVaporization Dealloc");
}

@end
