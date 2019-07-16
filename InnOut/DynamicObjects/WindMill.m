//
//  WindMill.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 10..
//  Copyright 2011 Student. All rights reserved.
//

#import "WindMill.h"


@implementation WindMill

-(id)init {
	if ( (self = [super init] ) ) {
		tower = [CCSprite spriteWithFile:@"Object_windmill_bridge.png"];
		wheel = [CCSprite spriteWithFile:@"Object_windmill_wheel.png"];
		[[tower texture] setAliasTexParameters];
		//[[wheel texture] setAliasTexParameters];
		
		wheel.anchorPoint = ccp(0.5f,0.5f);
		wheel.position = ccp(0,35);
		[self addChild:tower];
		[self addChild:wheel];
		
	}
	NSLog(@"WindMill Initialize");
	return self;
}

-(void)update:(ccTime)delta {
	wheel.rotation += [[GameCondition sharedGameCondition] windSpeed] *delta ;
	if (wheel.rotation > 360) {
		wheel.rotation -= 360;
	}
	//NSLog(@"%f",wheel.rotation);
}

-(void)dealloc {
	
	//[self removeChild:tower cleanup:YES];
	//[self removeChild:wheel cleanup:YES];
	[super dealloc];
	NSLog(@"WindMill Dealloc");
}
@end
