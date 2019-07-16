//
//  Bubble.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 5..
//  Copyright 2011 -. All rights reserved.
//

#import "Bubble.h"
#import "BubbleBubble.h"

@implementation Bubble


-(id)initWithBubble:(BubbleBubble*)MyManager_{
	if ( (self = [super init] ) ){
		MyManager = MyManager_;
		
		CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:@"stage3_Bubble.png"];
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
		self.opacity = 200;
        self.visible = NO;
        self.scale = (rand()%10)*0.025f + 0.25f;
        
        disappearYpos = rand()%200 + 120;
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
        if (disappearYpos - self.position.y >= 0) {
            float endAndcurRatio = 1-(self.position.y / disappearYpos); //끝점과 현재점의 비율을 계산한후에 투명도에 대입하기위해 반전시킴
            self.opacity = MyManager.beginOpacity*endAndcurRatio;
        }
		
		if (self.position.y > 320) {
			self.position = ccp(recycleScope.origin.x+(rand()%(int)recycleScope.size.width),recycleScope.origin.y + (rand()%(int)recycleScope.size.height));
			tp = ccp(self.position.x , 180 + (rand()%20));
            
			elapsedTime = 0;
			self.opacity = MyManager.beginOpacity;
			if (MyManager.maintainParticleNum < MyManager.activatedParticleCount) {
				[self unActivate];
			}
		}
        //NSLog(@"activated");
        //NSLog(@"Opacity:%d",self.opacity);
       // NSLog(@"Position x:%f y:%f",self.position.x,self.position.y);
	}else {
		if (MyManager.maintainParticleNum > MyManager.activatedParticleCount) {
			[self activate];
			
		}
        //NSLog(@"No activated");
	}
    
	
}

-(void)activate {
	if (activated == NO) {
        self.visible = YES;
		activated = YES;
		NSLog(@"opacity:%d",MyManager.beginOpacity);
		self.opacity = MyManager.beginOpacity;
		MyManager.activatedParticleCount++;
        self.scale = (rand()%10)*0.025f + 0.25f;
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
