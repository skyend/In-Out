//
//  ParticleManager.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 29..
//  Copyright 2011 Student. All rights reserved.
//

#import "ParticleManager.h"
#import "ParticleVaporization.h"

@implementation ParticleManager
@synthesize maintainParticleNum,activatedParticleCount,createParticleNum,createScope;
@synthesize beginOpacity,endOpacity;

-(id)initWithKind:(ParticleImgCode)code_ ParticleNum:(int)cretedParticleNum_ maintainParticleNum:(int)maintainParticleNum_ scope:(CGRect)createScope_{
	if ( (self = [super init] )) {
		particleArr = [[NSMutableArray alloc] init];
		createParticleNum = cretedParticleNum_;
		maintainParticleNum = maintainParticleNum_;
		createScope = createScope_;
		
		activatedParticleCount = 0;
		
		
		for (int i = 0; i < createParticleNum; i++) {
			ParticleVaporization * particle = [[[ParticleVaporization alloc] initWithKind:code_ myManager:self] autorelease];
			[self addChild:particle];
			[particleArr addObject:particle];

			if (i < maintainParticleNum) {
				[particle activate];
			}
		}
		
	}
	NSLog(@"ParticleManager Initialize");
	return self;
}


-(void)update:(ccTime)dt {
	
	for(ParticleVaporization * o in particleArr){
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
