//
//  BubbleBubble.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 5..
//  Copyright 2011 -. All rights reserved.
//

#import "BubbleBubble.h"
#import "Bubble.h"
#import "ProgressManager.h"
#import "GameCondition.h"

@implementation BubbleBubble

@synthesize maintainParticleNum,activatedParticleCount,createParticleNum,createScope;
@synthesize beginOpacity,endOpacity;

-(id)initWithCount:(int)cretedParticleNum_ scope:(CGRect)createScope_{
	if ( (self = [super init] )) {
		particleArr = [[NSMutableArray alloc] init];
		createParticleNum = cretedParticleNum_;
		maintainParticleNum = createParticleNum*0.4f;
		createScope = createScope_;
		
		activatedParticleCount = 0;
		
        runningPM = [GameCondition sharedGameCondition].runningPM;
        
		
		for (int i = 0; i < createParticleNum; i++) {
			Bubble * bubble = [[[Bubble alloc] initWithBubble:self] autorelease];
			[self addChild:bubble];
			[particleArr addObject:bubble];
            
			if (i < maintainParticleNum) {
				[bubble activate];
			}
		}
		
	}
	NSLog(@"ParticleManager Initialize");
	return self;
}


-(void)update:(ccTime)dt {
	float activeCount = createParticleNum * (0.4f + (runningPM.PerfromFinalRelaytoMaxFinalRelay*0.4f) + (runningPM.PerfromNormaltoFinalRelay*0.2f));
    
    maintainParticleNum = (int)activeCount;
    //NSLog(@"maintainParticleNum:%d",maintainParticleNum);
	for(Bubble * o in particleArr){
		[o update:dt];
	}
}

-(void)dealloc {
	[self removeAllChildrenWithCleanup:YES];
	[particleArr removeAllObjects];
	[particleArr release];
	[super dealloc];
	NSLog(@"ParticleManager Dealloc");
}
@end
