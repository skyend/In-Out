//
//  Sun.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 17..
//  Copyright 2011 Student. All rights reserved.
//

#import "Sun.h"


@implementation Sun
@synthesize sun;

-(id)initSun {
	if ( ( self = [super init] ) ) {
        sun = nil;
		if ([GameCondition sharedGameCondition].stageCode == STAGE_2) {
            if (LastOpenedStageCode < 5) {
                sun = [CCSprite spriteWithFile:@"Object_Sun.png"];
                [[sun texture] setAliasTexParameters];
                sun.anchorPoint = ccp(0.5f,0.5f);
                [self addChild:sun];
            }
        }else{
            sun = [CCSprite spriteWithFile:@"Object_Sun.png"];
            [[sun texture] setAliasTexParameters];
            sun.anchorPoint = ccp(0.5f,0.5f);
            [self addChild:sun];
        }
		
		
	}
	NSLog(@"Sun Initialize");
	return self;
}

-(void)update:(ccTime)delta {
	if (sun != nil) {
        sun.rotation += 7*delta;
        
        if(sun.rotation > 360){
            sun.rotation -= 360;
        }
    }
	
	
}

-(void)dealloc {
	
	[super dealloc];
	NSLog(@"Sun Dealloc");
}

@end
